extends Node2D

class_name Space

# directions are bitmasks! this makes diagonals easier at the cost of a few nonsense directions
const FORWARD 	= 1 << 0 # 1
const BACKWARD 	= 1 << 1 # 2
const LEFT 		= 1 << 2 # 4
const RIGHT 	= 1 << 3 # 8
const UP		= 1 << 4 # 16
const DOWN		= 1 << 5 # 32
const DIRECTIONS_END = 1 << 6 #64

var board = null

var moused_over = false
var neighbors: Dictionary = {} # Dict of [ints (dir bitmasks), arrays of spaces]
@export var facets: Array[int]
@export var ridges: Array[int]
@export var peaks: Array[int]

var linked_moves: Array[Move] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_parent() is Board:
		add_to_board(get_parent())

func add_to_board(new_board):
	if (board):
		board.remove_space(self)
	new_board.add_space(self)
	board = new_board
	
func _exit_tree():
	remove_from_board()
	
func remove_from_board():
	if (board):
		board.remove_space(self)
	board = null
	
func add_neighbor(direction: int, space: Space):
	if not space:
		return
	if not neighbors.has(direction):
		neighbors[direction] = Array()
	neighbors[direction].append(space)
	
func remove_neighbor(direction: int, space: Space):
	if not neighbors.has(direction):
		push_error("This direction was never established")
	neighbors[direction].erase(space)
	
func traverse(direction: int) -> Array: #Array[Space]
	if not neighbors.has(direction):
		return []
	return neighbors.get(direction, [])
	
func traverse_dir(direction: int):
	return direction
	
func piece_entered(piece):
	print("space entered!")
	for child in get_children():
		if child is SpaceComponent:
			child.when_entered(self, piece)
			
func when_traversed(piece, direction):
	for child in get_children():
		if child is SpaceComponent:
			child.when_traversed(self, piece, direction)
			
func link_move(move: Move):
	if not linked_moves.has(move):
		linked_moves.append(move)
		
func unlink_move(move: Move):
	linked_moves.erase(move)

var turned_off_debug = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.debug_view:
		z_index = 1
		queue_redraw()
		turned_off_debug = false
	elif not turned_off_debug:
		queue_redraw()
		turned_off_debug = true
		
	if moused_over:
		for move in linked_moves:
			move.highlight = true
			if Input.is_action_just_pressed("LMB"):
				print("SPACE CLICKED")
				move.make()
	else:
		for move in linked_moves:
			move.highlight = false
			
		
	
func _draw():
	if Global.debug_view:
		for direction in neighbors:
			for neighbor in neighbors[direction]:
				var start = Vector2.ZERO
				var end = neighbor.global_position - global_position
				var disp: Vector2 = end - start
				var dir = disp.normalized() * 10
				var perp_dir = dir.rotated(PI/2)
				var color = Color.DARK_GREEN
				start += perp_dir * 2 + dir * 3
				end += perp_dir * 2 - dir * 3
				color.a = 0.5
				draw_line(start, end, color, 5)
				draw_polyline([end + dir, end + perp_dir, end - perp_dir, end + dir], color, 5)

func _on_Click_Detector_input_event(viewport, event, shape_idx):
	pass # Replace with function body.


func _on_Click_Detector_mouse_entered():
	moused_over = true


func _on_Click_Detector_mouse_exited():
	moused_over = false
