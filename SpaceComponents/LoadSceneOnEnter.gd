extends SpaceComponent


export(PackedScene) var scene


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func when_entered(space, piece):
	get_tree().change_scene_to(scene)
