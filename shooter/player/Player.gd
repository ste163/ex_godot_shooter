extends KinematicBody

export var mouse_sensitivity: float = 0.5

#onready means get something from current scene, and
# wait for it to load before continuing.
# $ is shorthand for that node.
onready var _camera = $Camera

# _process runs every frame, delta is time since last frame.
func _process(delta: float) -> void:
	exitGame();

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_mouseInput(event)

func _mouseInput(event: InputEvent) -> void:
	# get how much the mouse has moved on the x axis, times mouse sens
	# then apply that to our rotation on the y axis to turn the player left & right
	rotation_degrees.y -= mouse_sensitivity * event.relative.x
	# same as above, but moving the camera
	_camera.rotation_degrees.x -= mouse_sensitivity * event.relative.y
	# ensure you can't look passed -90 or 90 degrees
	_camera.rotation_degrees.x = clamp(_camera.rotation_degrees.x, -90, 90)

func exitGame() -> void:
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
