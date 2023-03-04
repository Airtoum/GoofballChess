extends Node

class_name PieceComponent, "res://Editor/BehaviourIcon.svg"
func get_class(): return "PieceComponent"

export(String) var component_name
export(String, MULTILINE) var description

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func when_dropped(piece):
	pass
	
func when_try_move(piece):
	return true
	
func when_moved(piece):
	pass

func when_dragged(piece):
	pass
	
func when_get_moves(piece, list_of_moves):
	pass
