extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	if Input.is_action_just_pressed("debug_pause"):
		var x = 1 - 1
		var y = 1 / x


signal select_click_2d

signal deselect_all

# critera_function(entity) -> bool, true means selected
signal select(criteria_function: Callable)

# critera_function(entity) -> bool, true means selectable
signal choose(criteria_function: Callable)
