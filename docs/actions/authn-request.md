# Authentication Requests Semantic Conventions

Used when span name is `authn-request`

<!-- semconv contrast.action.span.authn(full) -->
| Attribute  | Type | Description  | Examples  | Requirement Level |
|---|---|---|---|---|
| `contrast.authentication.mechanism` | string | An authentication mechanism is a specific method or approach used to verify the identity of a user, system, or entity attempting to access a resource. | `password`; `token`; `biometric` | Recommended |
| `contrast.authentication.protocol` | string | An authentication protocol is a set of rules and procedures that dictate how authentication mechanisms should operate to establish trust and verify identities securely. | `oauth`; `saml`; `ldap`; `custom` | Recommended |

`contrast.authentication.mechanism` MUST be one of the following:

| Value  | Description |
|---|---|
| `password` | Users provide a username and password. |
| `certificate` | x509 certificate authentication or similar |
| `token` | Involves using a physical or virtual token to authenticate a user |
| `biometric` | file open or create action |
| `mfa` | Two or more of the above mechanisms are used |

`contrast.authentication.protocol` MUST be one of the following:

| Value  | Description |
|---|---|
| `saml` | Security Assertion Markup Language |
| `oauth` | Open Authentication and OIDC |
| `ldap` | Lightweight Directory Access Protocol |
| `kerberos` |  |
<!-- endsemconv -->
