extends Character

export var mouse_sensitivity: float = 0.5

#onready means get something from current scene, and
# wait for it to load before continuing.
# $ is shorthand for that node.
onready var _camera = $Camera
var _move_vect: Vector3 = Vector3()

# what to load before starting game
func _ready() -> void:
	# hide mouse cursor and lock it to center of screen
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)	

# _process runs every frame, delta is time since last frame.
func _process(delta: float) -> void:
	_movementInputs()

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
	
func _movementInputs() -> void:
	if Input.is_action_pressed("move_forward"):
		_move_vect += Vector3.FORWARD
	if Input.is_action_pressed("move_backward"):
		_move_vect += Vector3.BACK
	if Input.action_press("move_left"):
		_move_vect += Vector3.LEFT
	if Input.action_press("move_right"):
		_move_vect += Vector3.RIGHT
