# Semantic Conventions for `el-execution` Actions

Used when span name is `el-execution`.

<!-- semconv contrast.action.span.el-execution(full) -->

| Attribute       | Type   | Description                                          | Examples                                                                       | Requirement Level |
| --------------- | ------ | ---------------------------------------------------- | ------------------------------------------------------------------------------ | ----------------- |
| `code.contents` | string | The code representing the expression being executed. | `#{'String1 ' + 'string2'}`; `#{20 - 1}`; `'Just a string value'.substring(5)` | Required          |

<!-- endsemconv -->
