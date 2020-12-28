extends Particles

#when timer ends, emit particle
func _on_Timer_timeout(extra_arg_0: bool) -> void:
	emitting = true
