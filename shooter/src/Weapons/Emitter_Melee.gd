extends Area
class_name Emitter_Melee

var bodies_to_exclude: Array = []
var damage: int = 1 #default value will be over-ridden by each weapon

func set_damage(_damage: int) -> void:
	damage = _damage

func set_bodies_to_exclude(_bodies_to_exclude: Array) -> void:
	bodies_to_exclude = _bodies_to_exclude

func fire() -> void:
	pass #every Emitter has a fire method that gets overridden
