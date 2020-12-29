extends Spatial

onready var _anim_player: AnimationPlayer = $AnimationPlayer
onready var _bullet_emitters_base: Spatial = $BulletEmitters
onready var _bullet_emitters = $BulletEmitters.get_children()

signal fired
signal out_of_ammo

export var automatic = false

var fire_point: Spatial
var bodies_to_exlcude: Array = [] #pass into bullet emitters

export var damage: int = 5 #how much damage each bullet does
export var ammo: int = 30

export var attack_rate: float = 0.2
var _attack_timer: Timer
var _can_attack: bool = true

func _ready() -> void:
	_createTimer()

func init(_fire_point: Spatial, _bodies_to_exlcude: Array) -> void:
	_setEmitters(_fire_point, _bodies_to_exlcude)
	
func set_active() -> void:
	show()
	
func set_inactive() -> void:
	_anim_player.play("Idle")
	hide()
	
func attack(attack_input_just_pressed: bool, attack_input_held: bool) -> void:
	_canAttack(attack_input_just_pressed, attack_input_held)
	#start attacking
	var start_transform: Transform = _bullet_emitters_base.global_transform
	_bullet_emitters_base.global_transform = fire_point.global_transform
	for e in _bullet_emitters:
		e.fire()
	_bullet_emitters_base.global_transform = start_transform
	_anim_player.stop() #stop it first, so it plays from beginning each time
	_anim_player.play("Attack")
	emit_signal("fired")
	_can_attack = false #we just attacked so start timer
	_attack_timer.start()
	

func _canAttack(attack_input_just_pressed: bool, attack_input_held: bool) -> void:
	if not _can_attack:
		return
	if automatic and not attack_input_held:
		return
	elif not automatic and not attack_input_just_pressed:
		return
	
	if ammo == 0:
		if attack_input_just_pressed:
			emit_signal("out_of_ammo")
		return
	if ammo > 0:
		ammo -= 1
		
func _finish_attack() -> void:
	_can_attack = true

#create the timer here, but we won't start it until we start attacking
func _createTimer() -> void:
	_attack_timer = Timer.new()
	_attack_timer.wait_time = attack_rate
	_attack_timer.connect("timeout", self, "finish_attack")
	_attack_timer.one_shot = true
	add_child(_attack_timer)
	
func _setEmitters(_fire_point: Spatial, _bodies_to_exlcude: Array) -> void:
	fire_point = _fire_point
	bodies_to_exlcude = _bodies_to_exlcude
	for e in _bullet_emitters:
		e.set_damage(damage)
		e.set_bodies_to_exclude(bodies_to_exlcude)
