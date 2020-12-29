extends Emitter_Melee

func fire() -> void:
	for body in get_overlapping_bodies(): #get_overlapping_bodies is a built-in method
		if body.has_method("hurt") and not body in bodies_to_exclude:
			#get direction of the hit area collision box to the enemy, so we know where you hit from
			body.hurt(damage, global_transform.origin.direction_to(body.global_transform.origin))
