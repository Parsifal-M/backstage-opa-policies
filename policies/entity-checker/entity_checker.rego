package entity_checker

default allow := false

allow {
	count({v | v := violation[_]; v.level == "error"}) == 0
}

# Here we are checking and sending a warning if the tags are not set
violation[{"message": msg, "level": "warning"}] {
	not input.metadata.tags
	msg := "You do not have any tags set!"
}

# Here we are checking that the lifecycle is one of the valid lifecycles
violation[{"message": msg, "level": "error"}] {
	valid_lifecycles := {"production", "development", "experimental"}
	not valid_lifecycles[input.spec.lifecycle]
	msg := "Incorrect lifecycle, should be one of production, development or experimental"
}

# Here we check if the system is present
violation[{"message": msg, "level": "error"}] {
	not is_system_present
	msg := "System is missing!"
}

# Here we are checking that the component type is one of the valid types
violation[{"message": msg, "level": "error"}] {
	valid_types := {"website", "library", "service"}
	not valid_types[input.spec.type]
	not valid_types
	msg := "Incorrect component type!"
}

# True or false if the system is present
is_system_present {
	input.spec.system
}
