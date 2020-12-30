class_name HitBox
extends Area

signal hit

export var weak_spot: bool = false
export var critical_damage_multiplier: int = 2

func on_hit(damage: int, dir: Vector3) -> void:
	if weak_spot:
		emit_signal("hit", damage * critical_damage_multiplier)
	else:
		emit_signal("hit", damage, dir)
