# Resource additions from Contrast

<!-- semconv contrast.resource(full) -->
| Attribute  | Type | Description  | Examples  | Requirement Level |
|---|---|---|---|---|
| `contrast.semconv.version` | string | The version of contrast semantic conventions that the data adheres to. | `0.1.0` | Required |
| `deployment` | string | deployment environment | `QA` | Required |
| `otel.semconv.version` | string | The version of otel semantic conventions that the data adheres to. | `1.22.0` | Required |

`deployment` MUST be one of the following:

| Value  | Description |
|---|---|
| `QA` | quality assurance environment |
| `DEVELOPMENT` | development environment |
| `PRODUCTION` | production environment |
<!-- endsemconv -->
