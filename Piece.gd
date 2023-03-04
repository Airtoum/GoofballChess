extends Node2D

class_name Piece
func get_class(): return "Piece"

onready var ClickTimer = $PieceInternals/ClickTimer

export(String) var piece_name

export(Color) var hover_color
export(Color) var select_color

var moused_over
var selected
var dragged
var drag_offset = Vector2.ZERO
var drag_start = position
var screen_click_start = Vector2.ZERO
var screen_click_radius = 10

var board = null

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_parent().get_class() == "Board":
		add_to_board(get_parent())

func add_to_board(new_board):
	if (board):
		board.remove_piece(self)
	new_board.add_piece(self)
	board = new_board
	
func _exit_tree():
	remove_from_board()
	
func remove_from_board():
	if (board):
		board.remove_piece(self)
	board = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if selected:
		self.modulate = select_color
	elif moused_over:
		self.modulate = hover_color
	else:
		self.modulate = Color(1,1,1)
	var mouse_pos = get_global_mouse_position()
	if dragged:
		self.global_position = mouse_pos + drag_offset
	 

func _input(event):
	var mouse_pos = get_global_mouse_position()
	if moused_over:
		if event is InputEventMouseButton:
			if event.pressed:
				dragged = true
				drag_offset = self.global_position - mouse_pos
				drag_start = self.position
				get_tree().set_input_as_handled()
				Cursor.clear_expand(self)
				ClickTimer.start()
				screen_click_start = event.position
				emit_dragged()
			else:
				dragged = false
				emit_dropped()
				if emit_try_move():
					move(drag_start, position)
					emit_moved()
				else:
					position = drag_start
				var click_diff = event.position - screen_click_start
				var click_is_close = click_diff.length() < screen_click_radius
				if ClickTimer.time_left > 0 && click_is_close:
					selected = !selected

func move(old_pos, new_pos):
	drag_start = new_pos
	if board:
		board.move_piece(self, old_pos, new_pos)


func _on_Click_Detector_mouse_entered():
	moused_over = true
	Cursor.call_deferred("start_to_expand", self)


func _on_Click_Detector_mouse_exited():
	moused_over = false
	Cursor.clear_expand(self)


func emit_dropped():
	for child in get_children():
		if child is PieceComponent:
			child.call("when_dropped", self)

func emit_try_move():
	for child in get_children():
		if child is PieceComponent:
			if not child.call("when_try_move", self):
				return false
	return true

func emit_moved():
	for child in get_children():
		if child is PieceComponent:
			child.call("when_moved", self)
			
func emit_dragged():
	for child in get_children():
		if child is PieceComponent:
			child.call("when_dragged", self)
			
func emit_get_moves():
	var list_of_moves = []
	for child in get_children():
		if child is PieceComponent:
			child.call("when_get_moves", self, list_of_moves)

func has_component(name):
	for child in get_children():
		if child is PieceComponent:
			if child.component_name == name:
				return true
	return false
	
func get_component(name) -> PieceComponent:
	for child in get_children():
		if child is PieceComponent:
			if child.component_name == name:
				return child as PieceComponent
	return null

func _on_Click_Detector_input_event(viewport, event, shape_idx):
	pass # Replace with function body.
