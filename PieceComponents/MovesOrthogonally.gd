extends PieceComponent

class_name PC_MovesOrthogonally


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func when_get_moves(piece: Piece, list_of_moves):
	if piece.has_component("CanMoveToSpaces") and piece.has_component("InhabitsSpaces"):
		var inhabits_spaces = piece.get_component("InhabitsSpaces") as PC_InhabitsSpaces
		inhabits_spaces.inhabiting_space
	if piece.has_component("CanMoveOverNothing"):
		pass
