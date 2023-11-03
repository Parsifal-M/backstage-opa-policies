package rbac_policy

import future.keywords.if

# Helper method for constructing a conditional decision
CONDITIONAL(plugin_id, resource_type, conditions) := conditional_decision if {
	conditional_decision := {
		"result": "CONDITIONAL",
		"pluginId": pluginId,
		"resourceType": resourceType,
		"conditions": conditions,
	}
}

default decision := {"result": "DENY"}

permission := input.permission.name

claims := input.identity.claims

# decision := {"result": "ALLOW"} if {
# 	permission == "catalog.entity.read"
# }

# Conditional based on claims (groups a user belongs to)
decision := CONDITIONAL("catalog", "catalog-entity", {"anyOf": [{
	"resourceType": "catalog-entity",
	"rule": "IS_ENTITY_OWNER",
	"params": {"claims": claims},
}]}) if {
	permission == "catalog.entity.delete"
}

# Conditional decision based on the entity type
decision := CONDITIONAL("catalog", "catalog-entity", {"anyOf": [{
	"resourceType": "catalog-entity",
	"rule": "IS_ENTITY_KIND",
	"params": {"kinds": ["API"]},
}]}) if {
	permission == "catalog.entity.read"
}