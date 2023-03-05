extends PieceComponent

class_name PC_CannotMoveToOccupied


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func when_try_move(piece: Piece) -> bool:
	if piece.board:
		var pieces_here = piece.board.get_pieces_at_pos(piece.position)
		if pieces_here.size() == 0:
			return true
		for piece_here in pieces_here:
			if piece_here.has_component("OccupiesSpace"):
				return false
	return true
