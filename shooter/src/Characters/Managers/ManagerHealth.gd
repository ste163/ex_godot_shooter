extends Spatial

signal dead
signal hurt
signal healed
signal health_changed
signal gibbed

export var max_health: int = 100
var _cur_health: int = 1 # set to 1 as a default, so no matter what max_health is, it's reset properly

export var gib_at: int = -10

#run when game loads
func _ready() -> void:
	_init()

#run when health manager is first initilaized
func init() -> void:
	_cur_health = max_health
	emit_signal("health_changed", _cur_health)

#damage characters
func hurt(damage: int, dir: Vector3) -> void:
	if _cur_health <= 0:
		return
	else:
		_cur_health -= damage
		if _cur_health <= gib_at:
			#TODO make gib spawner
			emit_signal("gibbed")
		if _cur_health <= 0: #Checked twice in case they die after damage subtracted
			emit_signal("dead")
		else:
			emit_signal("hurt")
			
		emit_signal("health_changed", _cur_health)

#heal characters
func heal(amount: int) -> void:
	if _cur_health <= 0:
		return
	else:
		_cur_health += amount
		if _cur_health > max_health:
			_cur_health = max_health
			
		emit_signal("healed")
		emit_signal("health_changed", _cur_health)
