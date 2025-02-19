# Contrast Action Spans

<!-- toc -->

- [Definitions](#definitions)
- [Action Span Attributes](#action-span-attributes)
  * [Java Specific action types](#java-specific-action-types)

<!-- tocstop -->

## Definitions

The span name MUST be set to the action name:

```
<action name>
```

## Action Span Attributes

Each Action Span has attributes that describe the action observed. For instance, an `authn-request` span
will list the authentication mechanism along with other authentication-related attributes
An action span for the `storage-query` action will have a different set of attributes
targeted toward describing that action.

* [authn-request](authn-request.md)
* [authz-request](authz-request.md)
* [storage-query](storage-query.md)
* [file-open-create](file-open-create.md)
* [outbound-service-call](outbound_service_call.md)
* [url-forward](url-forward.md)
* [url-redirect](url-redirect.md)
* [host-cmd-exec](host-cmd-exec.md)
* [ldap-query](ldap-query.md)
* [smtp-exec](smtp-exec.md)

### Java Specific action types

* [el-execution](el-execution.md)
* [ognl-execution](ognl-execution.md)
