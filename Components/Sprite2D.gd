@tool
extends Component
class_name cSprite2D
@onready var self_node: Node2D = get_node(".")

@export var texture: Texture2D :
	set(value): texture = value; preview_color(null);

@export var normal_color: Color :
	set(value): normal_color = value; preview_color(value);
@export var selected_color: Color :
	set(value): selected_color = value; preview_color(value);
@export var primary_selected_color: Color :
	set(value): primary_selected_color = value; preview_color(value);
@export var hover_color: Color :
	set(value): hover_color = value; preview_color(value);
@export var hover_selected_color: Color :
	set(value): hover_selected_color = value; preview_color(value);
@export var hover_primary_selected_color: Color :
	set(value): hover_primary_selected_color = value; preview_color(value);


# Called when the node enters the scene tree for the first time.
func _ready():
	add_component_type("Sprite2D")
	self_node.modulate = normal_color


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint():
		return
	
	if not entity.hovered:
		self_node.modulate = normal_color
		if entity.selected:
			self_node.modulate = selected_color
		if Global.primary_selected == entity:
			self_node.modulate = primary_selected_color
	else: # entity.hovered
		self_node.modulate = hover_color
		if entity.selected:
			self_node.modulate = hover_selected_color
		if Global.primary_selected == entity:
			self_node.modulate = hover_primary_selected_color
		
	self_node.queue_redraw()
	
func _draw():
	if Engine.is_editor_hint():
		for sibling in get_parent().get_children():
			if sibling is cPosition2D:
				var texture_width = texture.get_width()
				var draw_position = sibling.vector * texture_width
				self_node.draw_texture(texture, draw_position)
	else:
		for position in entity.get_components("Position2D") as Array[cPosition2D]:
			self_node.draw_texture(texture, position.vector * texture.get_width())
			
func preview_color(color):
	if not Engine.is_editor_hint() or self_node == null:
		return
	self_node.modulate = color or self_node.modulate
	self_node.queue_redraw() 
