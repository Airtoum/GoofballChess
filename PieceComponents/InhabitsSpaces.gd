extends PieceComponent

class_name PC_InhabitsSpaces

var inhabiting_space: Space = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func when_moved(piece: Piece):
	if not piece.board: return
	var spaces_here = piece.board.get_spaces_at_pos(piece.position)
	if spaces_here.size() > 0:
		inhabiting_space = spaces_here[0]
		inhabiting_space.piece_entered(piece)
