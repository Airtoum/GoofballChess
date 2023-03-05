extends PieceComponent

class_name PC_OccuipiesSpace

var occupying_space: Space = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func when_moved(piece: Piece):
	var spaces_here = piece.board.get_spaces_at_pos(piece.position)
	if spaces_here.size() > 0:
		occupying_space = spaces_here[0]
