# Semantic Conventions for `file-open-create` Actions

Used when span name is `file-open-create`.

<!-- semconv contrast.action.span.file-open-create(full) -->
| Attribute  | Type | Description  | Examples  | Requirement Level |
|---|---|---|---|---|
| `file.open.flags` | string | The flags used when the file was opened or created. | `o_rdonly`; `o_rdwr` | Recommended |
| `file.open.path` | string | The absolute path that was accessed. | `/etc/myconfig`; `/foo/bar`; `/some/tmp` | Required |

`file.open.flags` MUST be one of the following:

| Value  | Description |
|---|---|
| `o_rdonly` | Read only access |
| `o_wronly` | Write only access |
| `o_rdwr` | Read/write access |
<!-- endsemconv -->
