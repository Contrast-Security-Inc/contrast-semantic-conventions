# Security Observability Semantic Conventions

The Semantic Conventions define a common set of (semantic) attributes which
provide meaning to data when collecting, producing and consuming it.
The Semantic Conventions specify among other things span names and kind, metric
instruments and units as well as attribute names, types, meaning and valid
values. For a detailed definition of the Semantic Conventions' scope see
[Semantic Conventions Stability](https://opentelemetry.io/docs/specs/otel/versioning-and-stability/#semantic-conventions-stability).
The benefit to using Semantic Conventions is in following a common naming
scheme that can be standardized across a codebase, libraries, and platforms.
This allows easier correlation and consumption of data.

Contrast standardizes on otel metrics and extend from them. See
[OTel Semantic Conventions v1.22.0](https://github.com/open-telemetry/semantic-conventions/tree/v1.22.0/docs)
for a foundational understanding of what we build on top of. As newer versions of the OTel Semantic Conventions are released
this document will be updated as needed to try and conform for maximum portability and usability of the data our sensors
produce.

While the OTel Semantic Conventions encompass a lot of technologies, and is growing, we will try to capture and replicate from
the specification what is important for Contrast's sensors.

Semantic Conventions by signals:

- [Resource](resource/README.md): Semantic Conventions for resources.
- [Trace](general/trace.md): Semantic Conventions for traces and spans.
- [Metrics](general/metrics.md): Semantic Conventions for metrics.

Semantic Conventions are defined for the following areas:

- [General](general/README.md): General Semantic Conventions.
- [Actions](actions/README.md): Semantic Conventions for Contrast Actions.
- [HTTP](http/README.md): Semantic Conventions for HTTP client and server operations.
