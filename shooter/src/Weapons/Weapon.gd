class_name Weapon
extends Spatial
#THIS SHOULD BE SEPARATED
#Where there is a WEAPON parent
#Then a Weapon_Bullet and a Weapon_Melee
#Currently the Machete uses a "BulletEmitter" instead of a "SwingEmitter"

signal fired
signal out_of_ammo

export var automatic = false
export var damage: int = 5 #how much damage each bullet does
export var ammo: int = 30
export var attack_rate: float = 0.2

var fire_point: Spatial
var bodies_to_exlcude: Array = [] #pass into bullet emitters

var _attack_timer: Timer
var _can_attack: bool = true

onready var _anim_player: AnimationPlayer = $AnimationPlayer
onready var _bullet_emitters_base: Spatial = $BulletEmitters
onready var _bullet_emitters = $BulletEmitters.get_children()

func _ready() -> void:
	_createTimer()

func init(_fire_point: Spatial, _bodies_to_exlcude: Array) -> void:
	_setEmitters(_fire_point, _bodies_to_exlcude)
	
func set_active() -> void:
	show()
	
func set_inactive() -> void:
	_anim_player.play("Idle")
	hide()

func is_idle() -> bool:
	return not _anim_player.is_playing() or _anim_player.current_animation == "Idle"

func attack(attack_input_just_pressed: bool, attack_input_held: bool) -> void:
	var can_attack: bool = false
	can_attack = _canAttack(attack_input_just_pressed, attack_input_held)
	if can_attack:
		_attacking()
	else:
		return

func _canAttack(attack_input_just_pressed: bool, attack_input_held: bool) -> bool:
	if not _can_attack:
		return false
	if automatic and not attack_input_held:
		return false
	elif not automatic and not attack_input_just_pressed:
		return false
	
	if ammo == 0:
		if attack_input_just_pressed:
			emit_signal("out_of_ammo")
		return false
	elif ammo > 0:
		ammo -= 1
		return true
	#should never run, but in case anything else occurs that shouldn't, run this
	else:
		return false
		
func _attacking() -> void:
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

func _finish_attack() -> void:
	_can_attack = true

func _setEmitters(_fire_point: Spatial, _bodies_to_exlcude: Array) -> void:
	fire_point = _fire_point
	bodies_to_exlcude = _bodies_to_exlcude
	for e in _bullet_emitters:
		e.set_damage(damage)
		e.set_bodies_to_exclude(bodies_to_exlcude)

#create the timer here, but we won't start it until we start attacking
func _createTimer() -> void:
	_attack_timer = Timer.new()
	_attack_timer.wait_time = attack_rate
	_attack_timer.connect("timeout", self, "_finish_attack")
	_attack_timer.one_shot = true
	_attack_timer.name = "AttackTimer"
	add_child(_attack_timer)
