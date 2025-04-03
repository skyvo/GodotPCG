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

#function to get the corresponding tile atlas for the given noise value
func CalculateCellType(noise_value) -> Vector2i:
	if noise_value <= water_level:
		#its water
		if noise_value <= water_level - 0.2:
			if noise_value <= water_level - 0.3:
				return(Vector2i(4,3))
			else:
				return(Vector2i(3,3))
		else:
			return(Vector2i(2,3))
	else:
		#its not water
		if noise_value >= water_level + 0.15:
			if noise_value >= water_level + 0.3:
				return(Vector2i(3,1))
			#rocks
			
			else:
				if noise_value >= water_level + 0.35:
					if noise_value >= water_level + 0.45:
						return(Vector2i(3,2))
					else:
						return(Vector2i(2,2))
				else:
					return(Vector2i(2,1))
		else:
			#sand
			if noise_value >= water_level +0.1:
				return(Vector2i(1,0))
			else:
				return(Vector2i(0,0))
