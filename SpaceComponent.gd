extends Node

class_name SpaceComponent, "res://Editor/BehaviourIcon.svg"
func get_class(): return "SpaceComponent"

export(String) var component_name
export(String, MULTILINE) var description

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func when_entered(space, piece):
	pass
	
func when_exited(space, piece):
	pass
	
func when_moved(space):
	pass
