# <img src="https://www.contrastsecurity.com/hubfs/favicon.png" alt="Contrast Icon" width="50" height=""> Contrast Semantic Conventions

[![Checks](https://github.com/Contrast-Security-OSS/contrast-semantic-conventions/workflows/Checks/badge.svg?branch=main)](https://github.com/Contrast-Security-OSS/contrast-semantic-conventions/actions?query=workflow%3A%22Checks%22+branch%3Amain)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/tag/open-telemetry/semantic-conventions.svg?logo=opentelemetry&&color=f5a800&label=Latest%20release)](https://github.com/open-telemetry/semantic-conventions/releases/latest)
[![Specification Version](https://img.shields.io/badge/OTel_specification_version-v1.37.0-blue?logo=opentelemetry&color=f5a800)](https://github.com/open-telemetry/opentelemetry-specification/releases/tag/v1.37.0)

This repo is built on top of [this otel specification version][SpecificationVersion]

Semantic Conventions are metric and attribute names that are defined so that they
mean the same thing to all parties producing and consuming sensor data.
Raw timeseries and span data are stored in schemaless datastores and thus there
is not a strictly defined schema file. This design allows for agents to all be
at various levels of support in what they produce while the consumers of the
data do the best with what they have.

The single source of truth of semantic convention definitions are the yaml
files in the `model/` directory. These definitions are meant to be machine
parsable so that model libraries can be generated for various languages.

The single source of truth for the semantic convention documentation are the
markdown files in the `docs/` directory. This encapsulates the data in the
`model/` directory in a human-digestible form.

The semantic convention definitions are used to fill in table data in the
semantic convention documentation. This is the same pattern as [opentelemetry's
semantic-convention](https://github.com/open-telemetry/semantic-conventions) repo.
Contrasts Security Observability builds on top of the existing semantic-conventions
of opentelemetry and this contrast-semantic-conventions document should be
interpreted as an addendum to the core opentelemtry semantic conventions standard.
This standard will be used for all signal data sent by Contrast sensors to that
proper dimensional correlation/association can be performed on the backend data
across all of our products.

## Read the docs

The human-readable version of the semantic conventions resides in the [docs](docs/README.md) folder.
Major parts of these Markdown documents are generated from the YAML definitions located in the [model](model/README.md) folder.

## Releases

Semantic Conventions are versioned and the semantic version used by an agent is
encoded as a Resource attribute. The backend will accept multiple semantic versions
in use simultaneously by different agent instances.

The Contrast Semantic Conventions version will encompass the version of the addendum
here and the core semantic conventions version which is [v1.22.0](https://github.com/open-telemetry/semantic-conventions/releases/tag/v1.22.0)
at the time of this writing.

[SpecificationVersion]: https://github.com/open-telemetry/opentelemetry-specification/tree/v1.26.0
