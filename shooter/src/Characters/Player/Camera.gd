extends Camera

export var recoil_x_degree_machinegun: float = 40.0
export var recoil_timer_machinegun: float = 0.01

var _minAngle: float = -90.0
var _maxAngle: float = 90.0

var _is_shooting_machinegun: bool = false
var _machinegun_timer: Timer

#when we fire a weapon, have a recoil amount that gets passed in
func _on_MachineGun_fired() -> void:
	_is_shooting_machinegun = true
	_machinegun_timer.start()

func _ready() -> void:
	_createMachinegunTimer()

func _physics_process(delta: float) -> void:
	if _is_shooting_machinegun == true:
		#handle up recoil
		var newXAngle: float
		var startXAngle = rotation_degrees.x
		var angleXAfterRecoil: float = rotation_degrees.x + recoil_x_degree_machinegun
		
		#randomize left and right recoil
		var newYAngle: float
		var recoil_y_degree_machinegun: float = rand_range(-10.0, 10.0)
		var startYAngle = rotation_degrees.y
		var angleYAfterRecoil: float = rotation_degrees.y + recoil_y_degree_machinegun
		
		#smooth the values between start and end recoil position
		newXAngle = lerp(startXAngle, angleXAfterRecoil, 0.1)
		newYAngle = lerp(startYAngle, angleYAfterRecoil, 0.1)
		
		#constantly reassign the new, smooth values as we're shooting
		rotation_degrees.x = clamp(newXAngle, _minAngle, _maxAngle)
		rotation_degrees.y = newYAngle

#cancel the recoil method during the physics process
func _stopMachineGunRecoil() -> void:
	_is_shooting_machinegun = false

func _createMachinegunTimer() -> void:
	_machinegun_timer = Timer.new()
	_machinegun_timer.wait_time = recoil_timer_machinegun
	_machinegun_timer.connect("timeout", self, "_stopMachineGunRecoil")
	_machinegun_timer.one_shot = true
	add_child(_machinegun_timer)
