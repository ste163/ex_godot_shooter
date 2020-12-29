extends Emitter

#Preload allows us to load this file when the game starts, not the scene
var hit_effect: PackedScene = preload("res://src/Effects/EffectHitBullet.tscn")

export var distance: int = 10000

func fire() -> void:
	var result: Dictionary
	result = _whatWasHit()
	#if whatever we hit has the "hurt" method. damage them
	if result and result.collider.has_method("hurt"):
		result.collider.hurt(damage, result.normal) #the normal will spray blood in the hit direction
	#if hit something that can't be hurt, instantiate the particle effect
	elif result: 
		_createAndOrientParticleEffect(result)

func _whatWasHit() -> Dictionary:
	var space_state: PhysicsDirectSpaceState = get_world().get_direct_space_state()
	var player_pos: Vector3 = global_transform.origin #get player's position
	#The Intersect Ray method means:
		#take the result of everything we've hit on the following layers in a line
		#from the player pos to the player position - global transform * distance,
		#store all the data of what we hit
		#the 1 + 2 + 4 comes from the values of the evironment, characters, and hitboxes layers
	var result: Dictionary = space_state.intersect_ray(player_pos, player_pos - global_transform.basis.z * distance,
		bodies_to_exclude, 1 + 2 + 4, true, true)
	return result

func _createAndOrientParticleEffect(result: Dictionary) -> void:
	var hit_effect_instance = hit_effect.instance()
	get_tree().get_root().add_child(hit_effect_instance) #get the root of the scene we're in
	hit_effect_instance.global_transform.origin = result.position #set the hit effect location to the location of where our bullet hit, but has no orientation
		
	#because the particle effect is already oriented up, if we hit a flat surface, don't re-orient the effect
	if result.normal.angle_to(Vector3.UP) < 0.00005:
		return
	if result.normal.angle_to(Vector3.DOWN) < 0.00005:
		hit_effect_instance.rotate(Vector3.RIGHT, PI) #PI = 180 degrees, so if we hit the ceiling, flip the effect upside down			return
		
		#cross products - when you have 2 vectors, this will get you what's perpendicular to them
		#allows us to get a correctly oriented particle effect
	var y: Vector3 = result.normal
	var x: Vector3 = y.cross(Vector3.UP)
	var z: Vector3 = x.cross(y)
		
	hit_effect_instance.global_transform.basis = Basis(x, y, z)
