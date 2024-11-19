# All documents to be used in spell check.
ALL_DOCS := $(shell find . -type f -name '*.md' -not -path './.github/*' -not -path './node_modules/*' | sort)
PWD := $(shell pwd)

# Determine OS & Arch for specific OS only tools on Unix based systems
OS := $(shell uname | tr '[:upper:]' '[:lower:]')
ifeq ($(OS),darwin)
	SED := gsed
else
	SED := sed
endif

# From where to resolve the containers (e.g. "otel/weaver").
CONTAINER_REPOSITORY=docker.io

# Per container overrides for the repository resolution.
WEAVER_CONTAINER_REPOSITORY=$(CONTAINER_REPOSITORY)
SEMCONVGEN_CONTAINER_REPOSITORY=$(CONTAINER_REPOSITORY)

# Fully qualified references to containers used in this Makefile.
# These are parsed from dependencies.Dockerfile so dependabot will autoupdate
# the versions of docker files we use.
WEAVER_CONTAINER=$(shell cat dependencies.Dockerfile | awk '$$4=="weaver" {print $$2}')
SEMCONVGEN_CONTAINER=$(shell cat dependencies.Dockerfile | awk '$$4=="semconvgen" {print $$2}')
OPA_CONTAINER=$(shell cat dependencies.Dockerfile | awk '$$4=="opa" {print $$2}')

DOCKER_USER=$(shell id -u):$(shell id -g)

TOOLS_DIR := ./internal/tools
MISSPELL_BINARY=bin/misspell
MISSPELL = $(TOOLS_DIR)/$(MISSPELL_BINARY)

# see https://github.com/open-telemetry/build-tools/releases for semconvgen updates
# Keep links in model/README.md and .vscode/settings.json in sync!
SEMCONVGEN_VERSION=0.22.0

# Contrast semantic specification builds on top of the otel semantic specification.
# This is the version of the otel semconv that we adhere to.  New releases of
# secobs-semantic-conventions may update the version of otel semantic conventions
# it depends on.  Any language libraries that are generated from the secobs semantic
# conventions should transitively offer the respective otel semantic convention
# libraries so that consumers are always forced to be in sync.
# see https://github.com/open-telemetry/semantic-conventions/releases
OTEL_SEMCONV_VERSION=1.22.0

.PHONY: all
all: install-tools markdown-toc table-generation fix-format check yamllint schema-check \
		 check-file-and-folder-names-in-docs

.PHONY: check-file-and-folder-names-in-docs
check-file-and-folder-names-in-docs:
	@found=`find docs -name '*_*'`; \
	if [ -n "$$found" ]; then \
		echo "Error: Underscores found in doc file or folder names, use hyphens instead:"; \
		echo $$found; \
		exit 1; \
	fi

$(MISSPELL):
	cd $(TOOLS_DIR) && go build -o $(MISSPELL_BINARY) github.com/client9/misspell/cmd/misspell

.PHONY: misspell
misspell:	$(MISSPELL)
	$(MISSPELL) -error $(ALL_DOCS)

.PHONY: misspell-correction
misspell-correction:	$(MISSPELL)
	$(MISSPELL) -w $(ALL_DOCS)

.PHONY: markdown-link-check
markdown-link-check:
	@if ! npm ls markdown-link-check; then npm install; fi
	@for f in $(ALL_DOCS); do \
		npx --no -- markdown-link-check --quiet --config .markdown_link_check_config.json $$f \
			|| exit 1; \
	done

.PHONY: markdown-link-check-changelog-preview
markdown-link-check-changelog-preview:
	@if ! npm ls markdown-link-check; then npm install; fi
	npx --no -- markdown-link-check --quiet --config .markdown_link_check_config.json changelog_preview.md;


# This target runs markdown-toc on all files that contain
# a comment <!-- tocstop -->.
#
# The recommended way to prepate a .md file for markdown-toc is
# to add these comments:
#
#   <!-- toc -->
#   <!-- tocstop -->
.PHONY: markdown-toc
markdown-toc:
	@if ! npm ls markdown-toc; then npm install; fi
	@for f in $(ALL_DOCS); do \
		if grep -q '<!-- tocstop -->' $$f; then \
			echo markdown-toc: processing $$f; \
			npx --no -- markdown-toc --no-first-h1 --no-stripHeadingTags -i $$f || exit 1; \
		else \
			echo markdown-toc: no TOC markers, skipping $$f; \
		fi; \
	done

.PHONY: markdownlint
markdownlint:
	@if ! npm ls markdownlint; then npm install; fi
	@npx gulp lint-md

.PHONY: markdownlint-old
markdownlint-old:
	@if ! npm ls markdownlint; then npm install; fi
	@for f in $(ALL_DOCS); do \
		echo $$f; \
		npx --no -p markdownlint-cli markdownlint -c .markdownlint.yaml $$f \
			|| exit 1; \
	done

.PHONY: install-yamllint
install-yamllint:
	# Using a venv is recommended
	pip install -U yamllint~=1.26.1

.PHONY: yamllint
yamllint:
	yamllint .

# Generate markdown tables from YAML definitions
.PHONY: table-generation
table-generation:
	docker run --rm \
		-u $(DOCKER_USER) \
		--mount 'type=bind,source=$(PWD)/templates,target=/home/weaver/templates,readonly' \
		--mount 'type=bind,source=$(PWD)/model,target=/home/weaver/source,readonly' \
		--mount 'type=bind,source=$(PWD)/docs,target=/home/weaver/target' \
		$(WEAVER_CONTAINER) registry update-markdown \
		--registry=/home/weaver/source \
		--attribute-registry-base-url=/docs/attributes-registry \
		--templates=/home/weaver/templates \
		--target=markdown \
		--future \
		/home/weaver/target

# Generate attribute registry markdown.
.PHONY: attribute-registry-generation
attribute-registry-generation:
	docker run --rm \
		-u $(DOCKER_USER) \
		--mount 'type=bind,source=$(PWD)/templates,target=/home/weaver/templates,readonly' \
		--mount 'type=bind,source=$(PWD)/model,target=/home/weaver/source,readonly' \
		--mount 'type=bind,source=$(PWD)/docs,target=/home/weaver/target' \
		$(WEAVER_CONTAINER) registry generate \
		  --registry=/home/weaver/source \
		  --templates=/home/weaver/templates \
		  markdown \
		  /home/weaver/target/attributes-registry/

# Check if current markdown tables differ from the ones that would be generated from YAML definitions (weaver).
.PHONY: table-check
table-check:
	docker run --rm \
		--mount 'type=bind,source=$(PWD)/templates,target=/home/weaver/templates,readonly' \
		--mount 'type=bind,source=$(PWD)/model,target=/home/weaver/source,readonly' \
		--mount 'type=bind,source=$(PWD)/docs,target=/home/weaver/target,readonly' \
		$(WEAVER_CONTAINER) registry update-markdown \
		--registry=/home/weaver/source \
		--attribute-registry-base-url=/docs/attributes-registry \
		--templates=/home/weaver/templates \
		--target=markdown \
		--dry-run \
		--future \
		/home/weaver/target

.PHONY: schema-check
schema-check:
	$(TOOLS_DIR)/schema_check.sh

.PHONY: check-format
check-format:
	npm run check:format

.PHONY: fix-format
fix-format:
	npm run fix:format

# Run all checks in order of speed / likely failure.
.PHONY: check
check: misspell markdownlint attribute-registry-generation markdown-link-check check-format check-policies
	@echo "All checks complete"

# Attempt to fix issues / regenerate tables.
.PHONY: fix
fix: table-generation attribute-registry-generation misspell-correction fix-format
	@echo "All autofixes complete"

.PHONY: install-tools
install-tools: $(MISSPELL)
	npm install
	@echo "All tools installed"

# A previous iteration of calculating "LATEST_RELEASED_SEMCONV_VERSION"
# relied on "git describe". However, that approach does not work with
# light-weight developer forks/branches that haven't synced tags. Hence the
# more complex implementation of this using "git ls-remote".
#
# The output of "git ls-remote" looks something like this:
#
#    e531541025992b68177a68b87628c5dc75c4f7d9        refs/tags/v1.21.0
#    cadfe53949266d33476b15ca52c92f682600a29c        refs/tags/v1.22.0
#    ...
#
# .. which is why some additional processing is required to extract the
# latest version number and strip off the "v" prefix.
LATEST_RELEASED_SEMCONV_VERSION := $(shell git ls-remote --tags https://github.com/open-telemetry/semantic-conventions.git | cut -f 2 | sort --reverse | head -n 1 | tr '/' ' ' | cut -d ' ' -f 3 | $(SED) 's/v//g')
.PHONY: check-policies
check-policies:
	docker run --rm \
		--mount 'type=bind,source=$(PWD)/policies,target=/home/weaver/policies,readonly' \
		--mount 'type=bind,source=$(PWD)/model,target=/home/weaver/source,readonly' \
		${WEAVER_CONTAINER} registry check \
		--registry=/home/weaver/source \
		--baseline-registry=https://github.com/open-telemetry/semantic-conventions/archive/refs/tags/v$(LATEST_RELEASED_SEMCONV_VERSION).zip[model] \
		--policy=/home/weaver/policies

# Test rego policies
.PHONY: test-policies
test-policies:
	docker run --rm -v $(PWD)/policies:/policies -v $(PWD)/policies_test:/policies_test \
	${OPA_CONTAINER} test \
    --var-values \
	--explain fails \
	/policies \
	/policies_test

# TODO: This is now duplicative with weaver policy checks.  We can remove
# once github action requirements are updated.
.PHONY: compatibility-check
compatibility-check:
	docker run --rm -v $(PWD)/model:/source -v $(PWD)/docs:/spec --pull=always \
		$(SEMCONVGEN_CONTAINER) --continue-on-validation-errors -f /source compatibility --previous-version $(LATEST_RELEASED_SEMCONV_VERSION)