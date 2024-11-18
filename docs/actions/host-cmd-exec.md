# Semantic Conventions for `host-cmd-exec` Actions

Used when span name is `host-cmd-exec`.

<!-- semconv contrast.action.span.host-cmd-exec(full) -->

| Attribute | Type   | Description                                    | Examples                                         | Requirement Level |
| --------- | ------ | ---------------------------------------------- | ------------------------------------------------ | ----------------- |
| `cmd`     | string | String of executed command with its arguments. | `ls /foo`; `bash -c somebin`; `chmod 755 foobar` | Required          |

<!-- endsemconv -->
