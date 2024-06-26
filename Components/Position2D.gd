@tool
extends Component
class_name cPosition2D

@export var vector: Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	add_component_type("Position")
	add_component_type("Position2D")

