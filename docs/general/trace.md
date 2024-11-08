# Trace Semantic Convention

For an encompassing description of trace semantics, see
[OTEL Trace Semantic Convention](https://github.com/open-telemetry/semantic-conventions/blob/v1.22.0/docs/general/trace.md).
The attributes described in this document will only described new attributes
added by Contrast Security or certain required attributes and highly desired
recommended attributes. However, all agents should strive to fill in as much data
as resonable guided by the OTEL specification.

The following semantic conventions for Contrast Spans are defined:

- [General](attributes.md): General semantic attributes that may be used in describing different kinds of operations.
- [Actions](../actions/action-spans.md): For spans describing Contrast Actions.
- [HTTP](../http/http-spans.md): For HTTP client and server spans.
