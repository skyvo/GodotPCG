extends Node
class_name MapGenerator
@export var chunk_manager : ChunkManager
@export var terrain_noise_texture : NoiseTexture2D
var terrain_noise : Noise 

@export_category("Map Settings")
@export var water_level : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	terrain_noise = terrain_noise_texture.noise
	pass # Replace with function body.

func CalculateCellType(noise_value) -> Vector2i:
	if noise_value <= water_level:
		#its water
		return(Vector2i(2,3))
	else:
		return(Vector2i(0,1))
