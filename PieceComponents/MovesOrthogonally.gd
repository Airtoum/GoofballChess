extends PieceComponent


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func when_get_moves(piece, list_of_moves):
	if piece.has_component("CanMoveToSpaces") and piece.has_component("InhabitsSpaces"):
		var space = piece.get_component("InhabitsSpaces").space
	if piece.has_component("CanMoveOverNothing"):
		pass