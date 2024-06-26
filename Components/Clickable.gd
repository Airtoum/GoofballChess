@tool
extends Component
class_name cClickable
@onready var self_node: Node2D = get_node(".")

var hovered_local = false

# Called when the node enters the scene tree for the first time.
func _ready():
	add_component_type("Clickable")
	if Engine.is_editor_hint():
		return
	GameEvents.select_click_2d.connect(event_select_click_2d)
	entity.ent_update_hovered.connect(ent_update_hovered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Rules for stacked clickables:
# if all off -> turn on first
# if one on -> turn it off, turn on next
# if last on -> turn it off

# This is done in two passes. The first pass looks to be consumed twice,
# once to turn a selected off, and again to turn the thing after the selected 
# on (next in sequence). The first pass may not get consumed, either because
# everything was off or the it only got consumed once by the very last thing.
# The second pass looks at the state of the first pass to decide if it should
# select the first in the sequence.

# single: if not selected, deselect all and select. if selected, deselect. if stacked, cycle
# additive: if not selected, select. if selected, select. if stacked, primary select next in stack after primary
# toggle: if not selected, select. if selected, deselect. if stacked, cycle
# special: if not selected, deselect all and select. if selected, select. if stacked, select primary from stack or select first in stack

enum select_modes {SINGLE, ADDITIVE, TOGGLE, SPECIAL}
enum select_process_modes {TURN_OFF, TURN_ON, PASS, SCAN, TURN_ON_FROM_SELECTED}

func _unhandled_input(event):
	# Hover behavour
	if event is InputEventMouseMotion:
		hovered_local = false
		for position in entity.get_components("Position2D") as Array[cPosition2D]:
			var rect = Rect2(position.vector.x * 100, position.vector.y * 100, 100, 100)
			if rect.has_point(event.global_position):
				hovered_local = true
	# Click behaviour
	if event is InputEventMouseButton and event.pressed and event.button_index in [MOUSE_BUTTON_LEFT, MOUSE_BUTTON_RIGHT]:
		event = event as InputEventMouseButton
		for position in entity.get_components("Position2D") as Array[cPosition2D]:
			var rect = Rect2(position.vector.x * 100, position.vector.y * 100, 100, 100)
			if rect.has_point(event.global_position):
				# begin algorithm that scans for stacked clickables
				var select_mode = (
					select_modes.SPECIAL if event.button_index == MOUSE_BUTTON_RIGHT else
					select_modes.TOGGLE if event.ctrl_pressed else 
					select_modes.ADDITIVE if event.shift_pressed else
					select_modes.SINGLE
				)
				var multi_event_data = {
					"mode": select_process_modes.SCAN if select_mode == select_modes.SPECIAL else select_process_modes.TURN_OFF, 
					"was_used": false, 
					"handling_components": {} # entity: component; used for many stacked clickables on same entity
				}
				var is_right_click = event.button_index == MOUSE_BUTTON_RIGHT
				GameEvents.select_click_2d.emit(event.global_position, 1, select_mode, is_right_click, multi_event_data)
				GameEvents.select_click_2d.emit(event.global_position, 2, select_mode, is_right_click, multi_event_data)
				get_viewport().set_input_as_handled()
				return
		
func event_select_click_2d(global_position: Vector2, pass_number: int, select_mode: select_modes, is_right_click: bool,  multi_event_data: Dictionary):
		var i_am_being_clicked_on = false
		for position in entity.get_components("Position2D") as Array[cPosition2D]:
			var rect = Rect2(position.vector.x * 100, position.vector.y * 100, 100, 100)
			if rect.has_point(global_position):
				i_am_being_clicked_on = true
				break
		if not i_am_being_clicked_on:
			return
		if multi_event_data["handling_components"].has(entity) and multi_event_data["handling_components"][entity] != self:
			return
		
		multi_event_data["handling_components"][entity] = self
		#var is_selected = entity.is_primary_selected() if select_mode in [select_modes.ADDITIVE, select_modes.SPECIAL] else entity.selected
		var is_selected = entity.selected
		var is_primary_selected = entity.is_primary_selected()
		match select_mode:
			select_modes.SINGLE:
				match pass_number:
					1:
						if is_selected and multi_event_data["mode"] == select_process_modes.TURN_OFF:
							entity.deselect()
							multi_event_data["mode"] = select_process_modes.TURN_ON
							multi_event_data["was_used"] = true
							GameEvents.deselect_all.emit()
							return
						if not is_selected and multi_event_data["mode"] == select_process_modes.TURN_ON:
							entity.select(is_right_click)
							multi_event_data["mode"] = select_process_modes.PASS
							return
					# if they were all off, select the first one
					2:
						if multi_event_data["was_used"]:
							# then we don't need to use it
							return
						if not is_selected:
							GameEvents.deselect_all.emit()
							entity.select(is_right_click)
							multi_event_data["was_used"] = true
							return
			select_modes.ADDITIVE:
				match pass_number:
					1:
						if is_primary_selected and multi_event_data["mode"] == select_process_modes.TURN_OFF:
							multi_event_data["mode"] = select_process_modes.TURN_ON
							multi_event_data["was_used"] = true
							return
						if not is_primary_selected and multi_event_data["mode"] == select_process_modes.TURN_ON:
							entity.select(is_right_click)
							multi_event_data["mode"] = select_process_modes.PASS
							return
					2:
						if multi_event_data["was_used"]:
							# special case for additive mode to cycle the primary selection around
							if multi_event_data["mode"] == select_process_modes.TURN_ON:
								multi_event_data["mode"] = select_process_modes.PASS
								entity.select(is_right_click)
							return
						if not is_selected:
							entity.select(is_right_click)
							multi_event_data["was_used"] = true
							return
			select_modes.TOGGLE:
				match pass_number:
					1:
						if is_selected and multi_event_data["mode"] == select_process_modes.TURN_OFF:
							entity.deselect()
							multi_event_data["mode"] = select_process_modes.TURN_ON
							multi_event_data["was_used"] = true
							return
						if not is_selected and multi_event_data["mode"] == select_process_modes.TURN_ON:
							entity.select(is_right_click)
							multi_event_data["mode"] = select_process_modes.PASS
							return
				
					# they were all off, select the first one
					2:
						if multi_event_data["was_used"]:
							# then we don't need to use it
							return
						if not is_selected:
							entity.select(is_right_click)
							multi_event_data["was_used"] = true
							return
			select_modes.SPECIAL:
				match pass_number:
					1:
						if is_primary_selected:
							entity.select(is_right_click)
							multi_event_data["mode"] = select_process_modes.PASS
							multi_event_data["was_used"] = true
							return
						if is_selected:
							multi_event_data["mode"] = select_process_modes.TURN_ON_FROM_SELECTED
							return
						if not is_selected and multi_event_data["mode"] != select_process_modes.TURN_ON_FROM_SELECTED:
							multi_event_data["mode"] = select_process_modes.TURN_ON
							return
					2:
						if multi_event_data["was_used"]:
							# then we don't need to use it
							return
						if is_selected and multi_event_data["mode"] == select_process_modes.TURN_ON_FROM_SELECTED:
							entity.select(is_right_click)
							multi_event_data["was_used"] = true
							return
						if not is_selected and multi_event_data["mode"] == select_process_modes.TURN_ON:
							GameEvents.deselect_all.emit()
							entity.select(is_right_click)
							multi_event_data["was_used"] = true
							return
							
		
			

func ent_update_hovered():
	if hovered_local:
		entity.hovered = true

func _draw():
	
	var color = Color("00b3b3a8")
	if Engine.is_editor_hint():
		for sibling in get_parent().get_children():
			if sibling is cPosition2D:
				var rect = Rect2(sibling.vector.x * 100, sibling.vector.y * 100, 100, 100)
				self_node.draw_rect(rect, color)
				pass
	else:
		for position in entity.get_components("Position2D") as Array[cPosition2D]:
			var rect = Rect2(position.vector.x * 100, position.vector.y * 100, 100, 100)
			self_node.draw_rect(rect, color)

