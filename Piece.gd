extends Node2D

class_name Piece


@onready var ClickTimer = $PieceInternals/ClickTimer

@export var piece_name: String

@export var hover_color: Color = Color("ffdd00")
@export var select_color: Color = Color("00ff00")

var moused_over
var selected
var dragged
var drag_offset = Vector2.ZERO
var drag_start = position
var screen_click_start = Vector2.ZERO
var screen_click_radius = 10

var list_of_moves: Array[Move] = []

var board = null

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_parent() is Board:
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
		self.self_modulate = select_color
	elif moused_over:
		self.self_modulate = hover_color
	else:
		self.self_modulate = Color(1,1,1)
	var mouse_pos = get_global_mouse_position()
	#if dragged:
	#	self.global_position = mouse_pos + drag_offset


func _input(event):
	# click -> select
	# when selected, click a space to pick a move
	# click + drag -> drag
	# when dragging, release over a space to pick a move
	# click + drag + release at start position -> select
	var mouse_pos = get_global_mouse_position()
	if moused_over:
		if event is InputEventMouseButton:
			if event.pressed:
				drag_offset = self.global_position - mouse_pos
				drag_start = self.position
				drag()
				get_viewport().set_input_as_handled()
				ClickTimer.start()
				screen_click_start = event.position
			else:
				dragged = false
				emit_dropped()
				var click_diff = event.position - screen_click_start
				var click_is_close = click_diff.length() < screen_click_radius
				if not click_is_close and position != drag_start:
					if emit_try_move() and false:
						#move_to(position)
						pass
					else:
						position = drag_start
				else:
					position = drag_start
				if ClickTimer.time_left > 0 && click_is_close:
					toggle_select()
	if dragged:
		if event is InputEventMouseMotion:
			self.global_position = mouse_pos + drag_offset
			var click_diff = event.position - screen_click_start
			var click_is_close = click_diff.length() < screen_click_radius
			if not click_is_close:
				#select()
				pass

func move_to(new_pos) -> void:
	position = new_pos
	move(drag_start, new_pos)
	emit_moved()

func move(old_pos, new_pos):
	drag_start = new_pos
	if board:
		board.move_piece(self, old_pos, new_pos)
	deselect()
	for move in list_of_moves:
		move.remove_listeners()

func toggle_select():
	selected = not selected
	if selected:
		select(true)
	else:
		deselect()

func select(bypass=false):
	if not selected or bypass:
		selected = true
		Cursor.selected_piece = self
		emit_get_moves()

func deselect():
	selected = false
	if Cursor.selected_piece == self:
		Cursor.selected_piece = null
		$PieceInternals/MoveDrawer.hide()
		$PieceInternals/MoveDrawer.queue_redraw()
		
func drag(bypass=false):
	if not dragged or bypass:
		dragged = true
		Cursor.clear_expand(self)
		emit_dragged()
		Cursor.selected_piece = self
		emit_get_moves()

func _on_Click_Detector_mouse_entered():
	moused_over = true
	Cursor.call_deferred("start_to_expand", self)


func _on_Click_Detector_mouse_exited():
	moused_over = false
	Cursor.clear_expand(self)

"""
class AllPieceComponents:
	var child_idx: int
	var node: Node
	func _init(node: Node):
		self.child_idx = 0
		self.node = node
	func should_continue():
		return self.child_idx < self.node.get_child_count()
	func find_next_piece_component(arg):
		print("find_next_piece_component started")
		if not should_continue():
			return false
		if not self.node.get_child(self.child_idx) is PieceComponent:
			return self._iter_next(arg)
		return should_continue()
	func _iter_init(arg):
		print("iter_init started")
		self.child_idx = 0
		return find_next_piece_component(arg)
	func _iter_next(arg):
		self.child_idx += 1
		return find_next_piece_component(arg)
	func _iter_get(arg) -> PieceComponent:
		return self.node.get_child(self.child_idx)
"""

func all_piece_components():
	var piece_components: Array[PieceComponent] = []
	for child in self.get_children():
		if child is PieceComponent:
			piece_components.append(child)
	return piece_components

func emit_dropped():
	for component in all_piece_components():
		component.when_dropped(self)

func emit_try_move() -> bool:
	for component in all_piece_components():
		if not component.when_try_move(self):
			return false
	return true

func emit_moved():
	for component in all_piece_components():
		component.when_moved(self)

func emit_dragged():
	for component in all_piece_components():
		component.when_dragged(self)

func emit_get_moves():
	list_of_moves = []
	for component in all_piece_components():
		component.when_get_moves(self, list_of_moves)
	
	for move in list_of_moves:
		move.setup_listeners()
	$PieceInternals/MoveDrawer.show()
	$PieceInternals/MoveDrawer.queue_redraw()
			
	if Global.debug_view:
		for move in list_of_moves:
			if move is MoveThroughSpaces:
				for space in move.spaces:
					space.modulate = (0.8) * space.modulate + (0.2) * Color.YELLOW

func has_component(name) -> bool:
	for component in all_piece_components():
		if component.component_name == name:
			return true
	return false
	
func get_component(name) -> PieceComponent:
	for component in all_piece_components():
		if component.component_name == name:
			return component
	return null


func _on_click_detector_input_event(viewport, event, shape_idx):
	pass # Replace with function body.


