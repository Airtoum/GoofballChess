@icon("res://Editor/BehaviourIcon.svg")
extends Node

class_name SpaceComponent

@export var component_name: String
@export_multiline var description: String

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func when_entered(space, piece):
	pass
	
func when_exited(space, piece):
	pass
	
func when_moved(space):
	pass

func when_traversed(space: Space, piece: Piece, direction: int):
	pass
