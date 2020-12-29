extends Camera

var _minAngle: float = -90.0
var _maxAngle: float = 90.0

export var recoil_degree_machinegun: float = 5.0
export var recoil_timer_machinegun: float = 0.05
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
		var newAngle: float
		var startAngle = rotation_degrees.x
		var angleAfterRecoil: float = rotation_degrees.x + recoil_degree_machinegun
		
		newAngle = lerp(startAngle, angleAfterRecoil, 0.1)
		rotation_degrees.x = clamp(newAngle, _minAngle, _maxAngle)
	else:
		rotation_degrees.x = rotation_degrees.x

func _stopMachineGunRecoil() -> void:
	_is_shooting_machinegun = false

func _createMachinegunTimer() -> void:
	_machinegun_timer = Timer.new()
	_machinegun_timer.wait_time = recoil_timer_machinegun
	_machinegun_timer.connect("timeout", self, "_stopMachineGunRecoil")
	_machinegun_timer.one_shot = true
	add_child(_machinegun_timer)
