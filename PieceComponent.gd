@icon("res://Editor/BehaviourIcon.svg")
extends Node

class_name PieceComponent

@export var component_name: StringName
@export_multiline var description: String

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func when_dropped(piece: Piece):
	pass
	
func when_try_move(piece: Piece) -> bool:
	return true
	
func when_moved(piece: Piece):
	pass

func when_dragged(piece: Piece):
	pass
	
func when_get_moves(piece: Piece, list_of_moves):
	pass
