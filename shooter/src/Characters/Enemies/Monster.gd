class_name Monster
extends Character
#Handles Monster State
#Prepares each Monster with hitboxes

enum STATES {IDLE, CHASE, ATTACK, DEAD}

export var sight_angle: float = 60.0
export var turn_speed: float = 250.0

var player: KinematicBody
var nav_path: Array = []
var cur_state = STATES.IDLE

onready var anim_player = $Graphics/AnimationPlayer
onready var health_manager = $ManagerHealth
onready var nav: Navigation = get_parent() #get the Navigation mesh

func _ready() -> void:
	player = get_tree().get_nodes_in_group("player")[0] #get the player node, which is the only item in the array
	set_state_idle()
	_prepare_hitboxes()

func _process(delta: float) -> void:
	match cur_state: #match is a switch statement for GDScript
		STATES.IDLE:
			process_state_idle(delta)
		STATES.CHASE:
			process_state_chase(delta)
		STATES.ATTACK:
			process_state_attack(delta)
		STATES.DEAD:
			process_state_dead(delta)

func set_state_idle() -> void:
	cur_state = STATES.IDLE
	anim_player.play("idle_loop")

func set_state_chase() -> void:
	cur_state = STATES.CHASE
	anim_player.play("walk_loop", 0.2)

func set_state_attack() -> void:
	cur_state = STATES.ATTACK

func set_state_dead() -> void:
	cur_state = STATES.DEAD
	anim_player.play("die")
	$CollisionShape.disabled = true
	freeze()

func process_state_idle(delta: float) -> void:
	if can_see_player():
		set_state_chase()

func process_state_chase(delta: float) -> void:
	var player_pos: Vector3 = player.global_transform.origin
	var monster_pos: Vector3 = global_transform.origin
	var goal_pos: Vector3 = player_pos
	var dir: Vector3
	
	nav_path = nav.get_simple_path(monster_pos, player_pos)
	
	if nav_path.size() > 1: #1 is the monster's current position
		goal_pos = nav_path[1]
	
	dir = goal_pos - monster_pos
	dir.y = 0 #remove the Y value so monster movies in a 2D vector
	
	set_move_vec(dir) #comes from Character
	face_dir(dir, delta)

func process_state_attack(delta: float) -> void:
	pass

func process_state_dead(delta: float) -> void:
	pass

func can_see_player() -> bool:
	#gets the monster's direction to the player
	var dir_to_player: Vector3 = global_transform.origin.direction_to(player.global_transform.origin)
	var forwards = global_transform.basis.z
	#checks what the angle the enemy is facing based on where the player is. If the player's direction is
	#less than the enemies sight_angle, AND the enemy has LOS then player is in the enemies cone of vision
	return rad2deg(forwards.angle_to(dir_to_player)) < sight_angle and has_los_player()

#LOS is line of sight
#gets LOS by raycasting from monster's position to the player's
#if the environment is NOT intersecting that ray, we have LOS
func has_los_player() -> bool:
	var monster_position: Vector3 = global_transform.origin + Vector3.UP #by adding V3.UP we send the raycast not from the "feet" but about the middle. Could change this for each enemy height to match eyes
	var player_position: Vector3 = player.global_transform.origin + Vector3.UP
	
	var space_state: PhysicsDirectSpaceState = get_world().get_direct_space_state()
	var result: Dictionary = space_state.intersect_ray(monster_position, player_position, [], 1) #don't exclude any bodies, and only intersect with enviro layer (1)
	if result:
		return false #the environment is blocking LOS
	else:
		return true 

#whenever we run alert, check if we have LOS before running
func alert(check_los: bool = true) -> void:
	#the checks to see if we're already in a non-idle state. If we are, don't alert me because
	#the other states would be alerted already or dead
	if cur_state != STATES.IDLE: 
		return
	if check_los and !has_los_player(): #if we don't have LOS, don't alert
		return
	else:
		set_state_chase()
		
#this signal is linked dynamically in the Monster method to each instance
func on_hit(damage: int, dir: Vector3) -> void:
	if cur_state == STATES.IDLE:
		set_state_chase()
	health_manager.hurt(damage, dir)

#face_dir has a lot of math I don't understand and wasn't explained
func face_dir(dir: Vector3, delta: float) -> void:
	var angle_diff = global_transform.basis.z.angle_to(dir)
	#turn_right works by doing some math that returns a positive number if the monster is facing right
	#and a negative when looking left.
	var turn_right = sign(global_transform.basis.x.dot(dir))
	#turn_speed * delta is how fast monster can turn in a frame
	if abs(angle_diff) < deg2rad(turn_speed) * delta: #this checks to see if we'll turn to far in a frame
		rotation.y = atan2(dir.x, dir.z)
	else:
		rotation.y += deg2rad(turn_speed) * delta * turn_right
		
func _prepare_hitboxes() -> void:
	#get all our bone attachment hitboxes
	var bone_attachments: Array = $Graphics/Armature/Skeleton.get_children()
	#for each bone in the list, get its child nodes
	for b in bone_attachments:
		for child in b.get_children():
			if child is HitBox:
				#for each hitbox, add the hit signal to this instance and
				#when the hit signal is emitted, call the "on_hit" method
				child.connect("hit", self, "on_hit")
