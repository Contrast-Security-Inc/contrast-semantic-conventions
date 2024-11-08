# Authorization Span Semantic Convention

Used when span name is `authz-request`

<!-- semconv contrast.action.span.authz(full) -->
| Attribute  | Type | Description  | Examples  | Requirement Level |
|---|---|---|---|---|
| `contrast.authorization.dac.permission` | string | Permission requested for access to the resource. The values here are very domain specific, but will always be normalized to a lowercase value in the data here. | `read`; `write`; `append`; `delete` | Recommended: If mechanism is 'dac' |
| `contrast.authorization.mac.labels` | string | Labels on the requested resource. The values here are very domain specific, but will always be normalized to a lowercase value in the data here. | `top_secret`; `confidential`; `internal`; `public` | Recommended: If mechanism is 'mac' |
| `contrast.authorization.mechanism` | string | How are authz decisions made for the resource. | `rbac`; `dac`; `pbac` | Recommended |
| `contrast.authorization.rbac.role` | string | Role Requested for authz check. The values here are very domain specific, but will always be normalized to a lowercase value in the data here. | `user`; `editor`; `manager` | Recommended: If mechanism is 'rbac' |

`contrast.authorization.mechanism` MUST be one of the following:

| Value  | Description |
|---|---|
| `rbac` | Role Based Access Control |
| `abac` | Attribute Based Access Control |
| `mac` | Mandatory Access Control (MAC) is a security model where access to resources is determined by the security labels assigned to subjects (users or processes) and objects (resources). |
| `dac` | Discretionary Access Control (DAC) is a model where owners of resources have the discretion to control access to their resources. |
| `pbac` | Policy Based Access Control |
| `hbac` | History Based Access Control |
| `tbac` | Time Based Access Control |
<!-- endsemconv -->
