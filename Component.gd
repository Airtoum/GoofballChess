extends Node

class_name Component

var game: Game = null
var id: int = -1

@export var entity: Entity
var component_types = []
var dependencies = []

func _enter_tree():
	if Engine.is_editor_hint():
		return
	search_for_parent_entity(self.get_parent())
	add_component_type("Component")

func search_for_parent_entity(ancestor_node: Node):
	if !ancestor_node:
		return
	if ancestor_node is Entity:
		entity = ancestor_node
		entity._register_component(self)
	else:
		search_for_parent_entity(ancestor_node.get_parent())
		

func add_component_type(type: StringName) -> void:
	if Engine.is_editor_hint():
		return
	component_types.append(type)
