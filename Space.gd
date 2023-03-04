extends Node2D

class_name Space
func get_class(): return "Space"

var board = null

var moused_over = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_parent().get_class() == "Board":
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
