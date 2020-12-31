extends Spatial
#ParticlesCache preloads all materials and particles
#and instances them in the player's view to compile material shaders
#this must be done with OpenGL because it compiles shaders on run time.
#Lives on the player's camera, and is so small the crosshair covers it

var effect_muzzle_flash: Material = preload("res://raw_assets/raw_meshes_flash/muzzleflash.material")

var monster_bird: Material = preload("res://assets/enemies/birdmonster.material")
var monster_reptile: Material = preload("res://assets/enemies/reptile.material")

var weapon_metal_black: Material = preload("res://raw_assets/raw_meshes_weapons/BlackMetal.material")
var weapon_metal_green: Material = preload("res://raw_assets/raw_meshes_weapons/GreenPlating.material")
var weapon_metal_shiny: Material = preload("res://raw_assets/raw_meshes_weapons/ShinyMetal.material")
var weapon_wood: Material = preload("res://raw_assets/raw_meshes_weapons/Wood.material")

var envir_bark: Material = preload("res://raw_assets/raw_meshes/bark.material")
var envir_metal_black: Material = preload("res://raw_assets/raw_meshes/BlackMetal.material")
var envir_metal_shiny: Material = preload("res://raw_assets/raw_meshes/ShinyMetal.material")
var envir_brick: Material = preload("res://raw_assets/raw_meshes/brick_ivy.material")
var envir_door: Material = preload("res://raw_assets/raw_meshes/door.material")
var envir_grass: Material = preload("res://raw_assets/raw_meshes/grass.material")
var envir_leaves: Material = preload("res://raw_assets/raw_meshes/leaves.material")
var envir_rock: Material = preload("res://raw_assets/raw_meshes/rock.material")
var envir_roof: Material = preload("res://raw_assets/raw_meshes/roof.material")
var envir_window: Material = preload("res://raw_assets/raw_meshes/window.material")
var envir_wood: Material = preload("res://raw_assets/raw_meshes/wood.material")

var particle_bullet: PackedScene = preload("res://src/Effects/EffectHitBullet.tscn")

var materials: Array = [
	effect_muzzle_flash,
	monster_bird,
	monster_reptile,
	weapon_metal_black,
	weapon_metal_green,
	weapon_metal_shiny,
	weapon_wood,
	envir_bark,
	envir_metal_black,
	envir_metal_shiny,
	envir_brick,
	envir_door,
	envir_grass,
	envir_leaves,
	envir_rock,
	envir_roof,
	envir_window,
	envir_wood,
]

func _ready() -> void:
	for material in materials:
		var mat_instance: MeshInstance = MeshInstance.new()
		mat_instance.set_mesh(QuadMesh.new())
		mat_instance.mesh.surface_set_material(0, material)
		mat_instance.cast_shadow = false
		self.add_child(mat_instance)
	
	self.add_child(particle_bullet.instance())
