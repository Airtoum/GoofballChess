@icon("res://Editor/EntIcon.svg")
extends Node

class_name Entity

var game: Game = null
var id: int = -1

var components: Array[Component] = []
@export var hovered = false
@export var selected = false

var context_menu = {}

signal ent_update_hovered

# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.deselect_all.connect(event_deselect_all)
	GameEvents.select.connect(event_select)
	
func _process(delta):
	hovered = false
	ent_update_hovered.emit()

func _register_component(component: Component) -> void:
	components.append(component)
	
func _deregister_component(component: Component) -> void:
	components.erase(component)

func has_component(component_type: StringName) -> bool:
	for component in self.components:
		if component_type in component.component_types:
			return true
	return false
	
func get_components(component_type: StringName) -> Array[Component]:
	var results: Array[Component] = []
	for component in self.components:
		if component_type in component.component_types:
			results.append(component)
	return results
	
func select(open_context_menu: bool = false):
	Global.primary_selected = self
	selected = true
	print(open_context_menu)
	
func deselect():
	if Global.primary_selected == self:
		Global.primary_selected = null
	selected = false

func event_deselect_all():
	deselect()

func is_primary_selected():
	return Global.primary_selected == self
	
	
func event_select(multi_event_data: Array[Entity], criteria_function: Callable):
	if criteria_function.call(self):
		multi_event_data.append(self)
		
func add_to_context_menu(name, function):
	self.context_menu[name] = function
