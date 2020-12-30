class_name Monster
extends Character
#Prepares each Monster with hitboxes

func _ready() -> void:
	#get all our bone attachment hitboxes
	var bone_attachments: Array = $Graphics/Armature/Skeleton.get_children()
	#for each bone in the list, get its child nodes
	for b in bone_attachments:
		for child in b.get_children():
			if child is HitBox:
				#for each hitbox, add the hit signal to this instance and
				#when the hit signal is emitted, call the "on_hit" method
				child.connect("hit", self, "on_hit")

#this signal is linked dynamically in the Monster method to each instance
func on_hit(damage: int, dir: Vector3) -> void:
	print("Hit!")
