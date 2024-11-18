# Semantic Conventions for Contrast Actions

Actions are a concept for Security Observability. They are modeled as a metric
so that actions are seen for every requests and collected in a scalable
manner for the agent. We will never miss an action on a particular execution path.

The data used in the action is captured as attributes within a span of a trace. Since capturing and processing spans is considered an expensive activity, this data is captured as part of a sampling activity.

Information in traces allow us to construct an action graph of the execution ordering and also gives us the same data used within an action. However, since they are sampled, its possible to miss some execution paths that execute other actions. Metrics contain what actions have occurred on an endpoint and are captured for every request, thus they will never miss a particular action. This fidelity comes at a cost however in that metrics will not contain data used in an
action nor will it contain enough information to determine the action execution order.

<!-- toc -->

- [Actions](#actions)
  * [Metrics](#metrics)
  * [Spans](#spans)

<!-- tocstop -->

## Actions

### Metrics

- [Action Metrics](action-metrics.md): Semantic Conventions for Action metrics.

### Spans

- [Action Spans](action-spans.md): Semantic Conventions for Action spans.
