extends PieceComponent


var inhabiting_space = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func when_moved(piece):
	var spaces_here = piece.board.get_spaces_at_pos(piece.position)
	if spaces_here.size() > 0:
		inhabiting_space = inhabiting_space[0]
