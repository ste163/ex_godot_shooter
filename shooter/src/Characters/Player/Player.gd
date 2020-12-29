extends Character

#weapon hotkeys
var hotkeys: Dictionary = {
	KEY_1: 0,
	KEY_2: 1,
	KEY_3: 2,
	KEY_4: 3,
	KEY_5: 4,
	KEY_6: 5,
	KEY_7: 6,
	KEY_8: 7,
	KEY_9: 8,
	KEY_0: 9
}

export var mouse_sensitivity: float = 0.2

#onready means get something from current scene, and
	#wait for it to load before continuing.
onready var _camera = $Camera
onready var _manager_health = $ManagerHealth
onready var _manager_weapon = $Camera/ManagerWeapon

var dead: bool = false

func _on_ManagerHealth_dead() -> void:
	died()

# what to load before starting game
func _ready() -> void:
	# hide mouse cursor and lock it to center of screen
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)	
	_manager_health.init()
	_manager_weapon.init($Camera/FirePoint, [self]) #firePoint is wherever we are looking, [self] is that we don't want to shoot us

# _process runs every frame, delta is time since last frame.
func _process(_delta: float) -> void:
	if dead:
		return
	else:
		_movementInputs()
		_attackInputs()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_mouseInput(event)
	if event is InputEventKey and event.pressed:
		_hotkeyInput(event)
	if event is InputEventMouseButton and event.pressed:
		_scrollWheelInput(event)

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

func _attackInputs() -> void:
	_manager_weapon.attack(Input.is_action_just_pressed("attack"),
		Input.is_action_pressed("attack"))

func _hotkeyInput(event: InputEvent) -> void:
	if event.scancode in hotkeys: #scancode is KEY_1 etc, they're built-ins
		_manager_weapon.switch_to_weapon_slot(hotkeys[event.scancode])

func _scrollWheelInput(event: InputEvent) -> void:
	if event.button_index == BUTTON_WHEEL_DOWN:
		_manager_weapon.switch_to_next_weapon()
	elif event.button_index == BUTTON_WHEEL_UP:
		_manager_weapon.switch_to_last_weapon()

#named the same as the health manager methods
func hurt(damage: int, dir: Vector3) -> void:
	_manager_health.hurt(damage, dir)
	
func heal(amount: int) -> void:
	_manager_health.heal(amount)

func died() -> void:
	dead = true
	freeze() # stop player from moving when dead
