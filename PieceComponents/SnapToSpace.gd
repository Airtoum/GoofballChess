extends PieceComponent

class_name PC_SnapToSpace

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Snaps to the nearest space
func when_dropped(piece: Piece):
	var spaces = piece.board.spaces
	var nearest_distance = INF
	var nearest_space = null
	for space in spaces:
		var dist = (piece.position - space.position).length()
		if dist < nearest_distance:
			nearest_distance = dist
			nearest_space = space
	if (nearest_space):
		piece.position = nearest_space.position
