# General Attributes

The attributes described in this section are not specific to a particular operation but rather generic.
They may be used in any Span they apply to.
Particular operations may refer to or require some of these attributes.

<!-- Re-generate TOC with `markdown-toc --no-first-h1 -i` -->

<!-- toc -->

- [Server, client and shared network attributes](#server-client-and-shared-network-attributes)
  * [Address and port attributes](#address-and-port-attributes)
  * [Server attributes](#server-attributes)
    + [`server.address`](#serveraddress)
  * [Client attributes](#client-attributes)
  * [Source and destination attributes](#source-and-destination-attributes)
    + [Source](#source)
    + [Destination](#destination)
  * [Other network attributes](#other-network-attributes)
    + [`network.peer.*` and `network.local.*` attributes](#networkpeer-and-networklocal-attributes)
      - [Client/server examples using `network.peer.*`](#clientserver-examples-using-networkpeer)
        * [Simple client/server example](#simple-clientserver-example)
        * [Client/server example with reverse proxy](#clientserver-example-with-reverse-proxy)
        * [Client/server example with forward proxy](#clientserver-example-with-forward-proxy)
- [General remote service attributes](#general-remote-service-attributes)
- [Source Code Attributes](#source-code-attributes)

<!-- tocstop -->

<!-- Keep old anchor IDs -->

<a name="server-and-client-attributes"></a>

## Server, client and shared network attributes

These attributes may be used to describe the client and server in a connection-based network interaction
where there is one side that initiates the connection (the client is the side that initiates the connection).
This covers all TCP network interactions since TCP is connection-based and one side initiates the
connection (an exception is made for peer-to-peer communication over TCP where the "user-facing" surface of the
protocol / API does not expose a clear notion of client and server).
This also covers UDP network interactions where one side initiates the interaction, e.g. QUIC (HTTP/3) and DNS.

In an ideal situation, not accounting for proxies, multiple IP addresses or host names,
the `server.*` attributes are the same on the client and server.

### Address and port attributes

For all IP-based protocols, the "address" should be just the IP-level address.
Protocol-specific parts of an address are split into other attributes (when applicable) such as "port" attributes for
TCP and UDP. If such transport-specific information is collected and the attribute name does not already uniquely
identify the transport, then setting [`network.transport`](#other-network-attributes) is especially encouraged.

### Server attributes

<!-- semconv server -->
| Attribute  | Type | Description  | Examples  | Requirement Level |
|---|---|---|---|---|
| `server.address` | string | Server address - domain name if available without reverse DNS lookup, otherwise IP address or Unix domain socket name. [1] | `example.com`; `10.1.2.80`; `/tmp/my.sock` | Recommended |
| `server.port` | int | Server port number. [2] | `80`; `8080`; `443` | Recommended |

**[1]:** When observed from the client side, and when communicating through an intermediary, `server.address` SHOULD represent
the server address behind any intermediaries (e.g. proxies) if it's available.

**[2]:** When observed from the client side, and when communicating through an intermediary, `server.port` SHOULD represent the server port behind any intermediaries (e.g. proxies) if it's available.
<!-- endsemconv -->

`server.address` and `server.port` represent logical server name and port. Semantic conventions that refer to these attributes SHOULD
specify what these attributes mean in their context.

#### `server.address`

For IP-based communication, the name should be a DNS host name of the service. On client side it matches remote service name, on server side, it represents local service name as seen externally on clients.

When connecting to an URL `https://example.com/foo`, `server.address` matches `"example.com"` on both client and server side.

On client side, it's usually passed in form of URL, connection string, host name, etc. Sometimes host name is only available to instrumentation as a string which may contain DNS name or IP address. `server.address` SHOULD be set to the available known hostname (e.g., `"127.0.0.1"` if connecting to an URL `https://127.0.0.1/foo`).

If only IP address is available, it should be populated on `server.address`. Reverse DNS lookup SHOULD NOT be used to obtain DNS name.

If `network.transport` is `"pipe"`, the absolute path to the file representing it should be used as `server.address`.
If there is no such file (e.g., anonymous pipe),
the name should explicitly be set to the empty string to distinguish it from the case where the name is just unknown or not covered by the instrumentation.

For Unix domain socket, `server.address` attribute represents remote endpoint address on the client side and local endpoint address on the server side.

### Client attributes

<!-- semconv client -->
| Attribute  | Type | Description  | Examples  | Requirement Level |
|---|---|---|---|---|
| `client.address` | string | Client address - domain name if available without reverse DNS lookup, otherwise IP address or Unix domain socket name. [1] | `client.example.com`; `10.1.2.80`; `/tmp/my.sock` | Recommended |
| `client.port` | int | Client port number. [2] | `65123` | Recommended |

**[1]:** When observed from the server side, and when communicating through an intermediary, `client.address` SHOULD represent the client address behind any intermediaries (e.g. proxies) if it's available.

**[2]:** When observed from the server side, and when communicating through an intermediary, `client.port` SHOULD represent the client port behind any intermediaries (e.g. proxies) if it's available.
<!-- endsemconv -->

### Source and destination attributes

These attributes may be used to describe the sender and receiver of a network exchange/packet. These should be used
when there is no client/server relationship between the two sides, or when that relationship is unknown.
This covers low-level network interactions (e.g. packet tracing) where you don't know if
there was a connection or which side initiated it.
This also covers unidirectional UDP flows and peer-to-peer communication where the
"user-facing" surface of the protocol / API does not expose a clear notion of client and server.

#### Source

<!-- semconv source -->
| Attribute  | Type | Description  | Examples  | Requirement Level |
|---|---|---|---|---|
| `source.address` | string | Source address - domain name if available without reverse DNS lookup, otherwise IP address or Unix domain socket name. [1] | `source.example.com`; `10.1.2.80`; `/tmp/my.sock` | Recommended |
| `source.port` | int | Source port number | `3389`; `2888` | Recommended |

**[1]:** When observed from the destination side, and when communicating through an intermediary, `source.address` SHOULD represent the source address behind any intermediaries (e.g. proxies) if it's available.
<!-- endsemconv -->

#### Destination

Destination fields capture details about the receiver of a network exchange/packet.

<!-- semconv destination -->
| Attribute  | Type | Description  | Examples  | Requirement Level |
|---|---|---|---|---|
| `destination.address` | string | Destination address - domain name if available without reverse DNS lookup, otherwise IP address or Unix domain socket name. [1] | `destination.example.com`; `10.1.2.80`; `/tmp/my.sock` | Recommended |
| `destination.port` | int | Destination port number | `3389`; `2888` | Recommended |

**[1]:** When observed from the source side, and when communicating through an intermediary, `destination.address` SHOULD represent the destination address behind any intermediaries (e.g. proxies) if it's available.
<!-- endsemconv -->

<a name="network-attributes"></a>

### Other network attributes

> **Warning**
> Attributes in this section are in use by the HTTP semantic conventions.
> Once the HTTP semantic conventions are declared stable, changes to the attributes in this section will only be allowed
> if they do not cause breaking changes to HTTP semantic conventions.

<!-- semconv network-core -->
| Attribute  | Type | Description  | Examples  | Requirement Level |
|---|---|---|---|---|
| `network.local.address` | string | Local address of the network connection - IP address or Unix domain socket name. | `10.1.2.80`; `/tmp/my.sock` | Recommended |
| `network.local.port` | int | Local port number of the network connection. | `65123` | Recommended |
| `network.peer.address` | string | Peer address of the network connection - IP address or Unix domain socket name. | `10.1.2.80`; `/tmp/my.sock` | Recommended |
| `network.peer.port` | int | Peer port number of the network connection. | `65123` | Recommended |
| `network.protocol.name` | string | [OSI application layer](https://wikipedia.org/wiki/Application_layer) or non-OSI equivalent. [1] | `amqp`; `http`; `mqtt` | Recommended |
| `network.protocol.version` | string | Version of the protocol specified in `network.protocol.name`. [2] | `3.1.1` | Recommended |
| `network.transport` | string | [OSI transport layer](https://wikipedia.org/wiki/Transport_layer) or [inter-process communication method](https://en.wikipedia.org/wiki/Inter-process_communication). [3] | `tcp`; `udp` | Recommended |
| `network.type` | string | [OSI network layer](https://wikipedia.org/wiki/Network_layer) or non-OSI equivalent. [4] | `ipv4`; `ipv6` | Recommended |

**[1]:** The value SHOULD be normalized to lowercase.

**[2]:** `network.protocol.version` refers to the version of the protocol used and might be different from the protocol client's version. If the HTTP client used has a version of `0.27.2`, but sends HTTP version `1.1`, this attribute should be set to `1.1`.

**[3]:** The value SHOULD be normalized to lowercase.

Consider always setting the transport when setting a port number, since
a port number is ambiguous without knowing the transport, for example
different processes could be listening on TCP port 12345 and UDP port 12345.

**[4]:** The value SHOULD be normalized to lowercase.

`network.transport` has the following list of well-known values. If one of them applies, then the respective value MUST be used, otherwise a custom value MAY be used.

| Value  | Description |
|---|---|
| `tcp` | TCP |
| `udp` | UDP |
| `pipe` | Named or anonymous pipe. See note below. |
| `unix` | Unix domain socket |

`network.type` has the following list of well-known values. If one of them applies, then the respective value MUST be used, otherwise a custom value MAY be used.

| Value  | Description |
|---|---|
| `ipv4` | IPv4 |
| `ipv6` | IPv6 |
<!-- endsemconv -->

#### `network.peer.*` and `network.local.*` attributes

These attributes identify network peers that are directly connected to each other.

`network.peer.address` and `network.local.address` should be IP addresses, Unix domain socket names, or other addresses specific to network type.

_Note: Specific structures and methods to obtain socket-level attributes are mentioned here only as examples. Instrumentations would usually use Socket API provided by their environment or sockets implementations._

When connecting using `connect(2)` ([Linux or other POSIX systems](https://man7.org/linux/man-pages/man2/connect.2.html) /
[Windows](https://docs.microsoft.com/windows/win32/api/winsock2/nf-winsock2-connect))
or `bind(2)`([Linux or other POSIX systems](https://man7.org/linux/man-pages/man2/bind.2.html) /
[Windows](https://docs.microsoft.com/windows/win32/api/winsock2/nf-winsock2-bind))
with `AF_INET` address family, `network.peer.address` and `network.peer.port` represent `sin_addr` and `sin_port` fields
of `sockaddr_in` structure.

`network.peer.address` and `network.peer.port` can be obtained by calling `getpeername` method
([Linux or other POSIX systems](https://man7.org/linux/man-pages/man2/getpeername.2.html) /
[Windows](https://docs.microsoft.com/windows/win32/api/winsock2/nf-winsock2-getpeername)).

`network.local.address` and `network.local.port` can be obtained by calling `getsockname` method
([Linux or other POSIX systems](https://man7.org/linux/man-pages/man2/getsockname.2.html) /
[Windows](https://docs.microsoft.com/windows/win32/api/winsock2/nf-winsock2-getsockname)).

##### Client/server examples using `network.peer.*`

Note that `network.local.*` attributes are not included in these examples since they are typically Opt-In.

###### Simple client/server example

![simple.png](simple.png)

###### Client/server example with reverse proxy

![reverse-proxy.png](reverse-proxy.png)

###### Client/server example with forward proxy

![forward-proxy.png](forward-proxy.png)

## General remote service attributes

This attribute may be used for any operation that accesses some remote service.
Users can define what the name of a service is based on their particular semantics in their distributed system.
Instrumentations SHOULD provide a way for users to configure this name.

<!-- semconv peer -->
| Attribute  | Type | Description  | Examples  | Requirement Level |
|---|---|---|---|---|
| `peer.service` | string | The [`service.name`](/docs/resource/README.md#service) of the remote service. SHOULD be equal to the actual `service.name` resource attribute of the remote service if any. | `AuthTokenCache` | Recommended |
<!-- endsemconv -->

Examples of `peer.service` that users may specify:

- A Redis cache of auth tokens as `peer.service="AuthTokenCache"`.
- A gRPC service `rpc.service="io.opentelemetry.AuthService"` may be hosted in both a gateway, `peer.service="ExternalApiService"` and a backend, `peer.service="AuthService"`.

## Source Code Attributes

Often a span is closely tied to a certain unit of code that is logically responsible for handling
the operation that the span describes (usually the method that starts the span).
For an HTTP server span, this would be the function that handles the incoming request, for example.
The attributes listed below allow to report this unit of code and therefore to provide more context
about the span.

<!-- semconv code -->
| Attribute  | Type | Description  | Examples  | Requirement Level |
|---|---|---|---|---|
| `code.column` | int | The column number in `code.filepath` best representing the operation. It SHOULD point within the code unit named in `code.function`. | `16` | Recommended |
| `code.filepath` | string | The source code file name that identifies the code unit as uniquely as possible (preferably an absolute file path). | `/usr/local/MyApplication/content_root/app/index.php` | Recommended |
| `code.function` | string | The method or function name, or equivalent (usually rightmost part of the code unit's name). | `serveRequest` | Recommended |
| `code.lineno` | int | The line number in `code.filepath` best representing the operation. It SHOULD point within the code unit named in `code.function`. | `42` | Recommended |
| `code.namespace` | string | The "namespace" within which `code.function` is defined. Usually the qualified class or module name, such that `code.namespace` + some separator + `code.function` form a unique identifier for the code unit. | `com.example.MyHttpService` | Recommended |
| `code.stacktrace` | string | A stacktrace as a string in the natural representation for the language runtime. The representation is to be determined and documented by each language SIG. | `at com.example.GenerateTrace.methodB(GenerateTrace.java:13)\n at com.example.GenerateTrace.methodA(GenerateTrace.java:9)\n at com.example.GenerateTrace.main(GenerateTrace.java:5)` | Opt-In |
<!-- endsemconv -->
