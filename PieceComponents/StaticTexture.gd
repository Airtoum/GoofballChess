extends PieceComponent

class_name PC_StaticTexture

@onready var self_node: TextureRect = get_node(".")
@export var inherit_parent_self_modulate: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if inherit_parent_self_modulate:
		self_node.self_modulate = get_parent().self_modulate
