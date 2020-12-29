extends Spatial

enum WEAPON_SLOTS {MACHETE, MACHINE_GUN, SHOTGUN, ROCKET_LAUNCHER}

var slots_unlocked: Dictionary = {
	WEAPON_SLOTS.MACHETE: true,
	WEAPON_SLOTS.MACHINE_GUN: true,
	WEAPON_SLOTS.SHOTGUN: true,
	WEAPON_SLOTS.ROCKET_LAUNCHER: true,
}

onready var weapons: Array = $Weapons.get_children()
var cur_slot: int = 0
var cur_weapon = null #unknown type for now
var fire_point: Spatial
var bodies_to_exclude: Array = []

func _ready() -> void:
	pass
	
func init(_fire_point: Spatial, _bodies_to_exclude: Array) -> void:
	fire_point = _fire_point
	bodies_to_exclude = _bodies_to_exclude
	for weapon in weapons:
		if weapon.has_method("init"):
			weapon.init(_fire_point, _bodies_to_exclude)
	switch_to_weapon_slot(WEAPON_SLOTS.MACHETE) #player always starts with Machete
	
func attack(attack_input_just_pressed: bool, attack_input_held: bool) -> void:
	if cur_weapon.has_method("attack"):
		cur_weapon.attack(attack_input_just_pressed, attack_input_held)

func switch_to_next_weapon() -> void:
	cur_slot = switch_to_slot("next")
	if not slots_unlocked[cur_slot]:
		switch_to_next_weapon()
	else:
		switch_to_weapon_slot(cur_slot)

func switch_to_last_weapon() -> void:
	cur_slot = switch_to_slot("last")
	if not slots_unlocked[cur_slot]:
		switch_to_last_weapon()
	else:
		 switch_to_weapon_slot(cur_slot)

func switch_to_slot(method_name: String) -> int:
	match method_name:
		"next":
			return (cur_slot + 1) % slots_unlocked.size() # the % means if the next slot is greater than the list, go back to 0
		"last":
			return posmod((cur_slot - 1), slots_unlocked.size()) # posmod allows it to be positive and wrap, doesn't work
		_:
			return cur_slot

func switch_to_weapon_slot(slot_index: int) -> void:
	if slot_index < 0 or slot_index >= slots_unlocked.size():
		return #so if we hit a key like 9 by accident, nothing will happen
	if not slots_unlocked[cur_slot]:
		return #if we haven't unlocked that slot, do nothing
	disable_all_weapons()
	cur_weapon = weapons[slot_index]
	if cur_weapon.has_method("set_active"):
		cur_weapon.set_active()
	else:
		cur_weapon.show()
	
func disable_all_weapons() -> void:
	for weapon in weapons:
		if weapon.has_method("set_inactive"):
			weapon.set_inactive()
		else:
			weapon.hide()
