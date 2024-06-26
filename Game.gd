extends Node
class_name Game


##
# Entities and Components need to be assigned a unique id.
# The ids need to be unique but only within the context of this game object,
# clones of this game object have their own set of ids and ents and components.
##
var ents = {}
var next_ent_id = 0
var components = {}
var next_component_id = 0

func _ready():
	for child in self.get_children():
		if child is Entity and (child as Entity).id != -1:
			self.add_entity(child)
		if child is Component and (child as Component).id != -1:
			self.add_component(child)

func add_entity(entity: Entity):
	entity.id = next_ent_id
	self.ents[next_ent_id] = entity
	self.next_ent_id += 1

func add_component(component: Component):
	component.id = next_component_id
	self.components[next_component_id] = component
	self.next_component_id += 1
