extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func linearly_approach(value, target, speed, delta):
	if (target - value > 0):
		return min(value + speed * delta, target)
	else:
		return max(value - speed * delta, target)
