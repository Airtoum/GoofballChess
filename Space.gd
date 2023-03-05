extends Node2D

class_name Space

# directions are bitmasks! this makes diagonals easier at the cost of a few nonsense directions
const FORWARD 	= 1 << 0
const BACKWARD 	= 1 << 1
const LEFT 		= 1 << 2
const RIGHT 	= 1 << 3
const UP		= 1 << 4
const DOWN		= 1 << 5
const DIRECTIONS_END = 1 << 6

var board = null

var moused_over = false
var neighbors: Dictionary = {} # Dict of [ints (dir bitmasks), arrays of spaces]

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
	if not neighbors.has(direction):
		neighbors[direction] = Array()
	neighbors[direction].append(space)
	
func remove_neighbor(direction: int, space: Space):
	if not neighbors.has(direction):
		push_error("This direction was never established")
	neighbors[direction].erase(space)
	
func piece_entered(piece):
	print("space entered!")
	for child in get_children():
		if child is SpaceComponent:
			child.when_entered(self, piece)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
	


func _on_Click_Detector_input_event(viewport, event, shape_idx):
	pass # Replace with function body.


func _on_Click_Detector_mouse_entered():
	moused_over = true


func _on_Click_Detector_mouse_exited():
	moused_over = false
