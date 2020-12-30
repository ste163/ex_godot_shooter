extends Camera
#Camera handles weapon recoil. I'm not sure how to DRY this
#as so much of these angles needs to occur in the _physics_process to recoil smoothly
#but that might just be the lerp and reassigning the rotation_degrees

var _min_angle: float = -90.0
var _max_angle: float = 90.0

var _is_shooting_machinegun: bool = false
var _machinegun_timer: Timer
var recoil_x_degree_machinegun: float = 40.0
var recoil_timer_machinegun: float = 0.01

#handle recoil while shooting
var _is_shooting_shotgun: bool = false
var _shotgun_timer: Timer
var recoil_x_degree_shotgun: float = 70.0
var recoil_timer_shotgun: float = 0.05

#when we fire a weapon, have a recoil amount that gets passed in
func _on_MachineGun_fired() -> void:
	_is_shooting_machinegun = true
	_machinegun_timer.start()
	
func _on_Shotgun_fired() -> void:
	_is_shooting_shotgun = true
	_shotgun_timer.start()

func _ready() -> void:
	_createMachinegunTimer()
	_createShotgunTimer()

func _physics_process(delta: float) -> void:
	if _is_shooting_machinegun == true:
		#handle up recoil
		var new_x_angle_mg: float
		var start_x_angle_mg: float = rotation_degrees.x
		var angle_x_after_recoil_mg: float = start_x_angle_mg + recoil_x_degree_machinegun
		
		#randomize left and right recoil
		var new_y_angle_mg: float
		var recoil_y_degree_mg: float = rand_range(-10.0, 10.0)
		var start_y_angle_mg = rotation_degrees.y
		var angle_y_after_recoil_mg: float = start_y_angle_mg + recoil_y_degree_mg
		
		#smooth the values between start and end recoil position
		new_x_angle_mg = lerp(start_x_angle_mg, angle_x_after_recoil_mg, 0.1)
		new_y_angle_mg = lerp(start_y_angle_mg, angle_y_after_recoil_mg, 0.1)
		
		#constantly reassign the new, smooth values as we're shooting
		rotation_degrees.x = clamp(new_x_angle_mg, _min_angle, _max_angle)
		rotation_degrees.y = new_y_angle_mg
		
	if _is_shooting_shotgun == true:
		#handle up recoil
		var new_x_angle_shotgun: float
		var start_x_angle_shotgun: float = rotation_degrees.x
		var angle_x_after_recoil_shotgun: float = start_x_angle_shotgun + recoil_x_degree_shotgun
		
		#randomize left and right recoil
		var new_y_angle_shotgun: float
		var recoil_y_degree_shotgun: float = rand_range(-30.0, 30.0)
		var start_y_angle_shotgun: float = rotation_degrees.y
		var angle_y_after_recoil_shotgun: float = start_y_angle_shotgun + recoil_y_degree_shotgun
		
		#smooth values between start and end recoil position
		new_x_angle_shotgun = lerp(start_x_angle_shotgun, angle_x_after_recoil_shotgun, 0.1)
		new_y_angle_shotgun = lerp(start_y_angle_shotgun, angle_y_after_recoil_shotgun, 0.1)
		
		rotation_degrees.x = clamp(new_x_angle_shotgun, _min_angle, _max_angle)
		rotation_degrees.y = new_y_angle_shotgun
		
#cancel the recoil method during the physics process
func _stopMachineGunRecoil() -> void:
	_is_shooting_machinegun = false

func _stopShotgunRecoil() -> void:
	_is_shooting_shotgun = false

func _createMachinegunTimer() -> void:
	_machinegun_timer = Timer.new()
	_machinegun_timer.wait_time = recoil_timer_machinegun
	_machinegun_timer.connect("timeout", self, "_stopMachineGunRecoil")
	_machinegun_timer.one_shot = true
	add_child(_machinegun_timer)

func _createShotgunTimer() -> void:
	_shotgun_timer = Timer.new()
	_shotgun_timer.wait_time = recoil_timer_shotgun
	_shotgun_timer.connect("timeout", self, "_stopShotgunRecoil")
	_shotgun_timer.one_shot = true
	add_child(_shotgun_timer)
