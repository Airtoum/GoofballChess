extends PieceComponent

class_name PC_SnapToMousedSpace

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Snaps to the moused over space
func when_dropped(piece: Piece):
	if not piece.board:
		return
	var spaces = piece.board.spaces
	var snap_to_space = null
	for space in spaces:
		if space.moused_over:
			snap_to_space = space
			break
	if (snap_to_space):
		piece.position = snap_to_space.position

