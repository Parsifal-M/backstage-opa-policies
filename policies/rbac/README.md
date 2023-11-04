# RBAC & Permission Policies

These policies are to help with RBAC and permissions in Backstage. They are to be used with the [OPA Backend](https://github.com/Parsifal-M/brewed-backstage/tree/main/plugins/opa-backend) and the [OPA Permissions Wrapper](https://github.com/Parsifal-M/brewed-backstage/tree/main/plugins/opa-permissions-wrapper) plugins.

## Conditional Rules

Backstage supports "conditional" rules for when we want to make more fine-grained decisions about whether or not a user should be able to access a resource. For example, we may want to allow a user to access a certain entity type only if they are a member of a certain team. This is where conditional rules come in.

A Conditional Rule will look like this:

```rego
conditional(plugin_id, resource_type, conditions) := {
	"result": "CONDITIONAL",
	"pluginId": plugin_id,
	"resourceType": resource_type,
	"conditions": conditions,
}
```

We accept a `plugin_id` and a `resource_type` to identify the resource we are applying the rule to. We also accept a `conditions` object that contains the conditions we want to check. An example of a `conditions` object for the catalog might look like this:

```rego
decision := conditional("catalog", "catalog-entity", {"anyOf": [{
	"resourceType": "catalog-entity",
	"rule": "IS_ENTITY_KIND",
	"params": {"kinds": ["API"]},
}]}) if {
	permission == "catalog.entity.read"
}
```

As you can see, we are setting the `plugin_id` to `catalog` and the `resource_type` to `catalog-entity`. We then check if the `permission` is a `catalog.entity.read` permission. What we have then created is a conditional rule that will check if the `permission` is `catalog.entity.read` you will only be able to see entities of kind `API`.

A crucial part of the conditional rules is the `rule` and `params` keys as each `rule` will accept certain `params`.