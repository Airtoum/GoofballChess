extends Node2D

class_name MoveDrawer

@onready var my_piece: Piece = get_parent().get_parent()

var num_paths: int = 0
var paths: Array[Move]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = Vector2.ZERO
	global_rotation = 0
	queue_redraw()

func _draw():
	num_paths = 0
	paths = []
	for move in my_piece.list_of_moves:
		move = move as Move
		if not move.highlight:
			continue
		num_paths += 1
		paths.append(move)
		
		if move is MoveThroughSpaces:
			move = move as MoveThroughSpaces
			var piece = move.piece
			var spaces = move.spaces
			var in_loop = move.in_loop
			var start = piece.global_position
			for space in spaces:
				var end = space.global_position
				var dir = (end - start).normalized() * 5
				var perp = dir.rotated(PI/2)
				var offset = Vector2.ZERO if not in_loop else Vector2(15, 0)
				draw_polyline([
						start + offset,
						end - dir + offset,
						end - dir + perp + offset,
						end + offset,
						end - dir - perp + offset,
						end - dir + offset
					], Color.DARK_RED if not in_loop else Color.GOLD, 5)
				start = end

