# Security Observability Semantic Conventions

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

## Model Definition Files

The model definition files have a particular schema associated to them that the
opentelemetry [semconvgen](https://github.com/open-telemetry/build-tools/blob/v0.22.0/semantic-conventions/README.md)
build tool interprets and processes. `semconvgen` is used to generate
documentation data from the definition files. Specific language agents can use
these definition files to generate library code.

The model definitions use a syntax defined at
[Semantic Convention YAML Language](https://raw.githubusercontent.com/open-telemetry/build-tools/v0.22.0/semantic-conventions/syntax.md)

## Releases

Semantic Conventions are versioned and the semantic version used by an agent is
encoded as a Resource attribute. The backend will accept multiple semantic versions
in use simultaneously by different agent instances.

The Contrast Semantic Conventions version will encompass the version of the addendum
here and the core semantic conventions version which is [v1.22.0](https://github.com/open-telemetry/semantic-conventions/releases/tag/v1.22.0)
at the time of this writing.

## Consuming the Semantic Convention Documentation

The markdown documentation along with any generated table information from
the definition files can be consumed by just pointing a browser to the `docs/`
directory in this repo.

[SpecificationVersion]: https://github.com/open-telemetry/opentelemetry-specification/tree/v1.26.0
