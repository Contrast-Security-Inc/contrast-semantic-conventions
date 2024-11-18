# Semantic Conventions for Action Metrics

Actions occur within the context of an Web Application.

## HTTP Server

Applications that are served from an HTTP server.

### Metric: `http.server.action.total`

This metric is required.

<!-- semconv metric.http.server.action.total(metric_table) -->

| Name                       | Instrument Type | Unit (UCUM) | Description                       |
| -------------------------- | --------------- | ----------- | --------------------------------- |
| `http.server.action.total` | Counter         | `{action}`  | A counter of actions for contrast |

<!-- endsemconv -->

<!-- semconv metric.http.server.action.total(full) -->

| Attribute             | Type   | Description                                                                                                 | Examples                                         | Requirement Level |
| --------------------- | ------ | ----------------------------------------------------------------------------------------------------------- | ------------------------------------------------ | ----------------- |
| `action`              | string | The type of action that was observed.                                                                       | `file-open-create`; `authn-request`              | Required          |
| `http.request.method` | string | HTTP request method. [1]                                                                                    | `GET`; `POST`; `HEAD`                            | Recommended       |
| `http.route`          | string | The matched route (path template in the format used by the respective server framework). See note below [2] | `/users/:userID?`; `{controller}/{action}/{id?}` | Recommended       |

**[1]:** HTTP request method value SHOULD be "known" to the instrumentation.
By default, this convention defines "known" methods as the ones listed in [RFC9110](https://www.rfc-editor.org/rfc/rfc9110.html#name-methods)
and the PATCH method defined in [RFC5789](https://www.rfc-editor.org/rfc/rfc5789.html).

If the HTTP request method is not known to instrumentation, it MUST set the `http.request.method` attribute to `_OTHER`.

If the HTTP instrumentation could end up converting valid HTTP request methods to `_OTHER`, then it MUST provide a way to override
the list of known HTTP methods. If this override is done via environment variable, then the environment variable MUST be named
OTEL_INSTRUMENTATION_HTTP_KNOWN_METHODS and support a comma-separated list of case-sensitive known HTTP methods
(this list MUST be a full override of the default known method, it is not a list of known methods in addition to the defaults).

HTTP method names are case-sensitive and `http.request.method` attribute value MUST match a known HTTP method name exactly.
Instrumentations for specific web frameworks that consider HTTP methods to be case insensitive, SHOULD populate a canonical equivalent.
Tracing instrumentations that do so, MUST also set `http.request.method_original` to the original value.

**[2]:** MUST NOT be populated when this is not supported by the HTTP server framework as the route attribute should have low-cardinality and the URI path can NOT substitute it.
SHOULD include the [application root](/docs/http/http-spans.md#http-server-definitions) if there is one.

`action` MUST be one of the following:

| Value                   | Description                                                          |
| ----------------------- | -------------------------------------------------------------------- |
| `storage-query`         | Functions that execute queries                                       |
| `file-open-create`      | file open or create action                                           |
| `url-forward`           | Any function designed to forward a request to another URL            |
| `url-redirect`          | Function that result in an http 302 redirect code sent to the client |
| `host-cmd-exec`         | system shell command execution                                       |
| `ldap-query`            | Functions that result in and ldap query operation                    |
| `smtp-exec`             | Functions that result in an SMTP command execution                   |
| `outbound-service-call` | Functions that result in external calls to other services            |
| `authn-request`         | Functions that perform authentication actions                        |
| `authz-request`         | Functions that perform authorization actions                         |
| `el-execution`          | Spring expression language execution                                 |
| `ognl-execution`        | Object-Graph Navigation Language expression execution.               |

`http.request.method` has the following list of well-known values. If one of them applies, then the respective value MUST be used, otherwise a custom value MAY be used.

| Value     | Description                                                         |
| --------- | ------------------------------------------------------------------- |
| `CONNECT` | CONNECT method.                                                     |
| `DELETE`  | DELETE method.                                                      |
| `GET`     | GET method.                                                         |
| `HEAD`    | HEAD method.                                                        |
| `OPTIONS` | OPTIONS method.                                                     |
| `PATCH`   | PATCH method.                                                       |
| `POST`    | POST method.                                                        |
| `PUT`     | PUT method.                                                         |
| `TRACE`   | TRACE method.                                                       |
| `_OTHER`  | Any HTTP method that the instrumentation has no prior knowledge of. |

<!-- endsemconv -->

### Metric: `http.server.request.duration`

This metric is required.

The documentation for this metric is duplicated from the OTEL Semantic Convention
[http metrics](https://github.com/open-telemetry/semantic-conventions/blob/v1.22.0/docs/http/http-metrics.md#metric-httpserverrequestduration) document.
It is replicated here for convenience to the readers and to note that it is a required metric for agents to capture.

This metric SHOULD be specified with
[`ExplicitBucketBoundaries`](https://github.com/open-telemetry/opentelemetry-specification/tree/v1.26.0/specification/metrics/api.md#instrument-advice)
of `[ 0.005, 0.01, 0.025, 0.05, 0.075, 0.1, 0.25, 0.5, 0.75, 1, 2.5, 5, 7.5, 10 ]`.

<!-- semconv metric.http.server.request.duration(metric_table) -->

| Name                           | Instrument Type | Unit (UCUM) | Description                       |
| ------------------------------ | --------------- | ----------- | --------------------------------- |
| `http.server.request.duration` | Histogram       | `s`         | Duration of HTTP server requests. |

<!-- endsemconv -->

<!-- semconv metric.http.server.request.duration(full) -->

| Attribute                                              | Type   | Description                                                                                                   | Examples                                         | Requirement Level                                             |
| ------------------------------------------------------ | ------ | ------------------------------------------------------------------------------------------------------------- | ------------------------------------------------ | ------------------------------------------------------------- |
| `error.type`                                           | string | Describes a class of error the operation ended with. [1]                                                      | `timeout`; `name_resolution_error`; `500`        | Conditionally Required: If request has ended with an error.   |
| `http.request.method`                                  | string | HTTP request method. [2]                                                                                      | `GET`; `POST`; `HEAD`                            | Required                                                      |
| `http.response.status_code`                            | int    | [HTTP response status code](https://tools.ietf.org/html/rfc7231#section-6).                                   | `200`                                            | Conditionally Required: If and only if one was received/sent. |
| `http.route`                                           | string | The matched route (path template in the format used by the respective server framework). See note below [3]   | `/users/:userID?`; `{controller}/{action}/{id?}` | Conditionally Required: If and only if it's available         |
| [`network.protocol.name`](../general/attributes.md)    | string | [OSI application layer](https://osi-model.com/application-layer/) or non-OSI equivalent. [4]                  | `http`; `spdy`                                   | Recommended: if not default (`http`).                         |
| [`network.protocol.version`](../general/attributes.md) | string | Version of the protocol specified in `network.protocol.name`. [5]                                             | `1.0`; `1.1`; `2`; `3`                           | Recommended                                                   |
| [`server.address`](../general/attributes.md)           | string | Name of the local HTTP server that received the request. [6]                                                  | `example.com`; `10.1.2.80`; `/tmp/my.sock`       | Opt-In                                                        |
| [`server.port`](../general/attributes.md)              | int    | Port of the local HTTP server that received the request. [7]                                                  | `80`; `8080`; `443`                              | Opt-In                                                        |
| `url.scheme`                                           | string | The [URI scheme](https://www.rfc-editor.org/rfc/rfc3986#section-3.1) component identifying the used protocol. | `http`; `https`                                  | Required                                                      |

**[1]:** If the request fails with an error before response status code was sent or received,
`error.type` SHOULD be set to exception type or a component-specific low cardinality error code.

If response status code was sent or received and status indicates an error according to [HTTP span status definition](/docs/http/http-spans.md),
`error.type` SHOULD be set to the status code number (represented as a string), an exception type (if thrown) or a component-specific error code.

The `error.type` value SHOULD be predictable and SHOULD have low cardinality.
Instrumentations SHOULD document the list of errors they report.

The cardinality of `error.type` within one instrumentation library SHOULD be low, but
telemetry consumers that aggregate data from multiple instrumentation libraries and applications
should be prepared for `error.type` to have high cardinality at query time, when no
additional filters are applied.

If the request has completed successfully, instrumentations SHOULD NOT set `error.type`.

**[2]:** HTTP request method value SHOULD be "known" to the instrumentation.
By default, this convention defines "known" methods as the ones listed in [RFC9110](https://www.rfc-editor.org/rfc/rfc9110.html#name-methods)
and the PATCH method defined in [RFC5789](https://www.rfc-editor.org/rfc/rfc5789.html).

If the HTTP request method is not known to instrumentation, it MUST set the `http.request.method` attribute to `_OTHER`.

If the HTTP instrumentation could end up converting valid HTTP request methods to `_OTHER`, then it MUST provide a way to override
the list of known HTTP methods. If this override is done via environment variable, then the environment variable MUST be named
OTEL_INSTRUMENTATION_HTTP_KNOWN_METHODS and support a comma-separated list of case-sensitive known HTTP methods
(this list MUST be a full override of the default known method, it is not a list of known methods in addition to the defaults).

HTTP method names are case-sensitive and `http.request.method` attribute value MUST match a known HTTP method name exactly.
Instrumentations for specific web frameworks that consider HTTP methods to be case insensitive, SHOULD populate a canonical equivalent.
Tracing instrumentations that do so, MUST also set `http.request.method_original` to the original value.

**[3]:** MUST NOT be populated when this is not supported by the HTTP server framework as the route attribute should have low-cardinality and the URI path can NOT substitute it.
SHOULD include the [application root](/docs/http/http-spans.md#http-server-definitions) if there is one.

**[4]:** The value SHOULD be normalized to lowercase.

**[5]:** `network.protocol.version` refers to the version of the protocol used and might be different from the protocol client's version. If the HTTP client used has a version of `0.27.2`, but sends HTTP version `1.1`, this attribute should be set to `1.1`.

**[6]:** See [Setting `server.address` and `server.port` attributes](/docs/http/http-spans.md#setting-serveraddress-and-serverport-attributes).

> **Warning**
> Since this attribute is based on HTTP headers, opting in to it may allow an attacker
> to trigger cardinality limits, degrading the usefulness of the metric.

**[7]:** See [Setting `server.address` and `server.port` attributes](/docs/http/http-spans.md#setting-serveraddress-and-serverport-attributes).

> **Warning**
> Since this attribute is based on HTTP headers, opting in to it may allow an attacker
> to trigger cardinality limits, degrading the usefulness of the metric.

`error.type` has the following list of well-known values. If one of them applies, then the respective value MUST be used, otherwise a custom value MAY be used.

| Value    | Description                                                                                       |
| -------- | ------------------------------------------------------------------------------------------------- |
| `_OTHER` | A fallback error value to be used when the instrumentation does not define a custom value for it. |

`http.request.method` has the following list of well-known values. If one of them applies, then the respective value MUST be used, otherwise a custom value MAY be used.

| Value     | Description                                                         |
| --------- | ------------------------------------------------------------------- |
| `CONNECT` | CONNECT method.                                                     |
| `DELETE`  | DELETE method.                                                      |
| `GET`     | GET method.                                                         |
| `HEAD`    | HEAD method.                                                        |
| `OPTIONS` | OPTIONS method.                                                     |
| `PATCH`   | PATCH method.                                                       |
| `POST`    | POST method.                                                        |
| `PUT`     | PUT method.                                                         |
| `TRACE`   | TRACE method.                                                       |
| `_OTHER`  | Any HTTP method that the instrumentation has no prior knowledge of. |

<!-- endsemconv -->
