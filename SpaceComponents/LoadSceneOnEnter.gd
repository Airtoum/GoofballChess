extends SpaceComponent


@export var scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func when_entered(space, piece):
	get_tree().change_scene_to_packed(scene)
