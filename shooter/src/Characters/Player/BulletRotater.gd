#BulletRotater rotates all HitScanEmitters, then
	#takes arguements from the Weapon script and passes
	#them into each HitScanEmitter, and it does this by sharing public method names
extends Spatial

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
	rotation.z = rand_range(0.0, (2 * PI))



