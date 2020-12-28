extends Character

export var mouse_sensitivity: float = 0.2

#onready means get something from current scene, and
	#wait for it to load before continuing.
onready var _camera = $Camera
onready var _manager_health = $ManagerHealth

var dead: bool = false

func _on_ManagerHealth_dead() -> void:
	died()

# what to load before starting game
func _ready() -> void:
	# hide mouse cursor and lock it to center of screen
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)	
	_manager_health.init()

# _process runs every frame, delta is time since last frame.
func _process(_delta: float) -> void:
	if dead:
		return
	else:
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
	var _move_vec: Vector3
	if Input.is_action_pressed("move_forward"):
		_move_vec += Vector3.FORWARD
	if Input.is_action_pressed("move_backward"):
		_move_vec += Vector3.BACK
	if Input.is_action_pressed("move_left"):
		_move_vec += Vector3.LEFT
	if Input.is_action_pressed("move_right"):
		_move_vec += Vector3.RIGHT
	if Input.is_action_pressed("jump"):
		jump()
		
	set_move_vec(_move_vec)

#named the same as the health manager methods
func hurt(damage: int, dir: Vector3) -> void:
	_manager_health.hurt(damage, dir)
	
func heal(amount: int) -> void:
	_manager_health.heal(amount)

func died() -> void:
	dead = true
	freeze() # stop player from moving when dead
