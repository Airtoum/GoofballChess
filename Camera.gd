extends Camera2D


@export var speed: float = 40


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("camera_right"):
		global_position.x += speed * zoom.x * delta
	if Input.is_action_pressed("camera_left"):
		global_position.x += -speed * zoom.x * delta
	if Input.is_action_pressed("camera_up"):
		global_position.y += -speed * zoom.y * delta
	if Input.is_action_pressed("camera_down"):
		global_position.y += speed * zoom.y * delta
