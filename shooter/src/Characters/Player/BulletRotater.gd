#BulletRotater rotates all HitScanEmitters, then
	#takes arguements from the Weapon script and passes
	#them into each HitScanEmitter, and it does this by sharing public method names

#overrides the mehtods set in Emitter_Bullet
extends Emitter_Bullet

onready var _childEmitters: Array = get_children()

func _on_Shotgun_fired() -> void:
	_rotateRandomly()

#then pass the set damage, bodies, and fire methods to those of the children
func set_damage(_damage: int) -> void:
	for e in _childEmitters:
		e.set_damage(_damage)

func set_bodies_to_exclude(_bodies_to_exclude: Array) -> void:
	for e in _childEmitters:
		e.set_bodies_to_exclude(_bodies_to_exclude)

func fire() -> void:
	for e in _childEmitters:
		e.fire()
	
func _rotateRandomly() -> void:
	#must have new rand_ranges every time or else it reuses the same range
	#and doesn't randomize properly
	rotation.z = rand_range(0.0, (2 * PI))
	for e in _childEmitters:
		e.rotation.z = rand_range(0.0, (2 * PI))
		e.translation.y = rand_range(-0.5, 0.5)
		e.translation.x = rand_range(-0.7, 0.2)
