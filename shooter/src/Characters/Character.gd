extends KinematicBody
class_name Character

export var move_accel: float = 4.0
export var max_speed: float = 25.0
var _drag: float = 0.0
export var jump_force: float  = 30.0
export var gravity: float = 65.0

var _pressed_jump: bool = false
var move_vec: Vector3
var _velocity: Vector3
var _snap_vec: Vector3 #Controls how we "stick" to the ground
export var ignore_rotation: bool = false #Allows us to tell Characters (specifically NPCs) to move relative to the world

signal movement_info 

var _frozen: bool = false #When a character dies, we'll be able to freeze them in place

func _ready() -> void:
	_drag = move_accel / max_speed

func _physics_process(delta: float) -> void:
	_calc_movement(delta)

func _calc_movement(delta: float) -> void:
	var _cur_move_vec: Vector3 = move_vec # direction we're facing
	var _grounded: bool = self.is_on_floor()
	
	if _frozen:
		return
	if not ignore_rotation:
		_cur_move_vec = _cur_move_vec.rotated(Vector3.UP, self.rotation.y)
	#Velocity is how many units we move per second
	#Times our acceleration by where we're facing
	#Drag the velocity down on the horizontal axes
	#Add Gravity
	_velocity += (move_accel * _cur_move_vec) - (_velocity * Vector3(_drag, 0, _drag)) + (gravity * Vector3.DOWN * delta)
	_velocity = self.move_and_slide_with_snap(_velocity, _snap_vec, Vector3.UP)
	if _grounded:
		_velocity.y = -0.01 #Ensures we stay on ground each frame
	if _grounded and _pressed_jump:
		_velocity.y = jump_force
		_snap_vec = Vector3.ZERO #Unsticks us from ground
	else:
		_snap_vec = Vector3.DOWN #Sticks us to ground if we haven't jumped
	_pressed_jump = false #Ensures pressed_jump can only be true for 1 physics frame
	emit_signal("movement_info", _velocity, _grounded)

func set_move_vec(_move_vec: Vector3) -> void:
	move_vec = _move_vec.normalized()

func jump() -> void:
	_pressed_jump = true
	
func freeze() -> void:
	_frozen = true

func unfreeze() -> void:
	_frozen = false
