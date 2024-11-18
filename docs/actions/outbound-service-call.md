# Semantic Conventions for `outbound-service-call` Actions

<!-- Re-generate TOC with `markdown-toc --no-first-h1 -i` -->

<!-- toc -->

- [outbound-service-call (http client) span duration](#outbound-service-call-http-client-span-duration)
- [HTTP request retries and redirects](#http-request-retries-and-redirects)

<!-- tocstop -->

Used when span name is `outbound-service-call`.

This span type represents an outbound HTTP request. There are two ways this can be achieved in an instrumentation:

1. Instrumentations SHOULD create an `outbound-service-call` span for each attempt to send an HTTP request over the wire.
   In case the request is resent, the resend attempts MUST follow the [HTTP resend spec](#http-request-retries-and-redirects).
   In this case, instrumentations SHOULD NOT (also) emit a logical encompassing `outbound-service-call` span.

2. If for some reason it is not possible to emit a span for each send attempt (because e.g. the instrumented library does not expose hooks that would allow this),
   instrumentations MAY create an `outbound-service-call` span for the top-most operation of the HTTP client.
   In this case, the `url.full` MUST be the absolute URL that was originally requested, before any HTTP-redirects that may happen when executing the request.

<!-- semconv contrast.action.span.outbound-service-call(full) -->

| Attribute                                          | Type   | Description                                                                                                                     | Examples                                                            | Requirement Level                                |
| -------------------------------------------------- | ------ | ------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------- | ------------------------------------------------ |
| `http.resend_count`                                | int    | The ordinal number of request resending attempt (for any reason, including redirects). [1]                                      | `3`                                                                 | Recommended: if and only if request was retried. |
| [`network.peer.address`](../general/attributes.md) | string | Peer address of the network connection - IP address or Unix domain socket name.                                                 | `10.1.2.80`; `/tmp/my.sock`                                         | Recommended: If different than `server.address`. |
| [`network.peer.port`](../general/attributes.md)    | int    | Peer port number of the network connection.                                                                                     | `65123`                                                             | Recommended: If `network.peer.address` is set.   |
| [`server.address`](../general/attributes.md)       | string | Host identifier of the ["URI origin"](https://www.rfc-editor.org/rfc/rfc9110.html#name-uri-origin) HTTP request is sent to. [2] | `example.com`; `10.1.2.80`; `/tmp/my.sock`                          | Required                                         |
| [`server.port`](../general/attributes.md)          | int    | Port identifier of the ["URI origin"](https://www.rfc-editor.org/rfc/rfc9110.html#name-uri-origin) HTTP request is sent to. [3] | `80`; `8080`; `443`                                                 | Conditionally Required: [4]                      |
| `url.full`                                         | string | Absolute URL describing a network resource according to [RFC3986](https://www.rfc-editor.org/rfc/rfc3986) [5]                   | `https://www.foo.bar/search?q=OpenTelemetry#SemConv`; `//localhost` | Required                                         |

**[1]:** The resend count SHOULD be updated each time an HTTP request gets resent by the client, regardless of what was the cause of the resending (e.g. redirection, authorization failure, 503 Server Unavailable, network issues, or any other).

**[2]:** Determined by using the first of the following that applies

- Host identifier of the [request target](https://www.rfc-editor.org/rfc/rfc9110.html#target.resource)
  if it's sent in absolute-form
- Host identifier of the `Host` header

If an HTTP client request is explicitly made to an IP address, e.g. `http://x.x.x.x:8080`, then
`server.address` SHOULD be the IP address `x.x.x.x`. A DNS lookup SHOULD NOT be used.

**[3]:** When [request target](https://www.rfc-editor.org/rfc/rfc9110.html#target.resource) is absolute URI, `server.port` MUST match URI port identifier, otherwise it MUST match `Host` header port identifier.

**[4]:** If not default (`80` for `http` scheme, `443` for `https`).

**[5]:** For network calls, URL usually has `scheme://host[:port][path][?query][#fragment]` format, where the fragment is not transmitted over HTTP, but if it is known, it should be included nevertheless.
`url.full` MUST NOT contain credentials passed via URL in form of `https://username:password@www.example.com/`. In such case username and password should be redacted and attribute's value should be `https://REDACTED:REDACTED@www.example.com/`.
`url.full` SHOULD capture the absolute URL when it is available (or can be reconstructed) and SHOULD NOT be validated or modified except for sanitizing purposes.

Following attributes MUST be provided **at span creation time** (when provided at all), so they can be considered for sampling decisions:

- [`server.address`](../general/attributes.md)
- [`server.port`](../general/attributes.md)
- `url.full`
<!-- endsemconv -->

## outbound-service-call (http client) span duration

There are some minimal constraints that SHOULD be honored:

- `outbound-service-call` spans SHOULD start sometime before the first request byte is sent. This may or may not include connection time.
- `outbound-service-call` spans SHOULD end sometime after the HTTP response headers are fully read (or when they fail to be read). This may or may not include reading the response body.

If there is any possibility for application code to not fully read the HTTP response
(and for the HTTP client library to then have to clean up the HTTP response asynchronously),
the HTTP client span SHOULD NOT be ended in this cleanup phase,
and instead SHOULD end at some point after the HTTP response headers are fully read (or fail to be read).
This avoids the span being ended asynchronously later on at a time
which is no longer directly associated with the application code which made the HTTP request.

Because of the potential for confusion around this, HTTP client library instrumentations SHOULD document their behavior around ending HTTP client spans.

## HTTP request retries and redirects

Retries and redirects cause more than one physical HTTP request to be sent.
A request is resent when an HTTP client library sends more than one HTTP request to satisfy the same API call.
This may happen due to following redirects, authorization challenges, 503 Server Unavailable, network issues, or any other.

Each time an HTTP request is resent, the `http.resend_count` attribute SHOULD be added to each repeated span and set to the ordinal number of the request resend attempt.
