extends Spatial

export var flash_time: float = 0.05
var _timer: Timer

func _on_MachineGun_fired() -> void:
	_flash()

func _ready() -> void:
	_timer = Timer.new()
	add_child(_timer)
	_timer.wait_time = flash_time
	_timer.connect("timeout", self, "_end_flash")
	hide() #load the muzzle flash, but keep hidden

func _flash() -> void:
	_timer.start() #each time we call _flash() it resets timer
	rotation.z = rand_range(0.0, (2 * PI))
	show()

func _end_flash() -> void:
	hide()
