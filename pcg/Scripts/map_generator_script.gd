extends Node
class_name MapGenerator
@export var chunk_manager : ChunkManager
@export var terrain_noise_texture : NoiseTexture2D
var terrain_noise : Noise 
var folliage_noise : Noise 

@export_category("Map Settings")
@export var water_level : float = 0.0
@export var fertility_noise_texture : NoiseTexture2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	terrain_noise = terrain_noise_texture.noise
	folliage_noise = fertility_noise_texture.noise
	pass # Replace with function body.

#function to get the corresponding tile atlas for the given noise value
func CalculateTerrainCellType(noise_value) -> Vector2i:
	if noise_value <= water_level:
		#its water
		if noise_value <= water_level - 0.2:
			if noise_value <= water_level - 0.3:
				#normal water
				return(Vector2i(4,3))
			else:
				#deep water
				return(Vector2i(3,3))
		else:
			#shallow water
			return(Vector2i(2,3))
	else:
		#its not water
		if noise_value >= water_level + 0.15:
			if noise_value <= water_level + 0.20:
				#dark_grass
				return(Vector2i(3,1))
			#rocks
			else:
				if noise_value >= water_level + 0.30:
					if noise_value >= water_level + .35:
						#dark rock
						if noise_value >= water_level + .45:
							#snow
							return(Vector2i(4,4))
						return(Vector2i(3,2))
					else:
						#rock
						return(Vector2i(2,2))
				else:
					#light_grass
					return(Vector2i(2,1))
		else:
			#sand
			if noise_value >= water_level +0.1:
				#dark_sand 
				return(Vector2i(1,0))
			else:
				#light sand
				return(Vector2i(0,0))
func CalculateFolliageCellType(folliage_noise_value, terrain_noise_value) -> Vector2i:
	if terrain_noise_value <= water_level:
		#its water
		if terrain_noise_value <= water_level - 0.2:
			if terrain_noise_value <= water_level - 0.3:
				#normal water
				return(Vector2i(5,5))
			else:
				#deep water
				return(Vector2i(5,5))
		else:
			#shallow water
			return(Vector2i(5,5))
	else:
		#its not water
		if terrain_noise_value >= water_level + 0.15:
			if terrain_noise_value <= water_level + 0.20:
				#dark_grass
				return(Vector2i(0,0))
			#rocks
			else:
				if terrain_noise_value >= water_level + 0.30:
					if terrain_noise_value >= water_level + .35:
						#dark rock
						if terrain_noise_value >= water_level + .45:
							#snow
							return(Vector2i(5,5))
						return(Vector2i(5,5))
					else:
						#rock
						return(Vector2i(5,5))
				else:
					#light_grass
					return(Vector2i(0,0))
		else:
			#sand
			if terrain_noise_value >= water_level +0.1:
				#dark_sand 
				return(Vector2i(0,2))
			else:
				#light sand
				return(Vector2i(5,5))
	
func CalculateGroundFolliageType(folliage_noise_value, terrain_noise_value) -> Vector2i:
	
	if terrain_noise_value <= water_level:
		#its water
		if terrain_noise_value <= water_level - 0.2:
			if terrain_noise_value <= water_level - 0.3:
				#normal water
				return(Vector2i(5,5))
			else:
				#deep water
				return(Vector2i(5,5))
		else:
			#shallow water
			return(Vector2i(5,5))
	else:
		var random_number : int = randi_range(0,10)
		#its not water
		if terrain_noise_value >= water_level + 0.15:
			if terrain_noise_value <= water_level + 0.20:
				#dark_grass
				if random_number > 9:		
					return(Vector2i(randi_range(2,4),4))
				else:			
					return(Vector2i(0,0))
			#rocks
			else:
				if terrain_noise_value >= water_level + 0.30:
					if terrain_noise_value >= water_level + .35:
						#dark rock
						if terrain_noise_value >= water_level + .45:
							#snow
							return(Vector2i(5,5))
						return(Vector2i(5,5))
					else:
						#rock
						return(Vector2i(5,5))
				else:
					#light_grass
					if random_number > 3:
						if random_number > 7:
							if random_number > 9:
								return(Vector2i(randi_range(2,4),4))
							else:
								return(Vector2i(randi_range(0,4),2))
					else:	
						return(Vector2i(randi_range(2,4),randi_range(0,2)))
		else:			
			#sand
			if terrain_noise_value >= water_level +0.1:
				#dark_sand 
				return(Vector2i(0,2))
			else:
				#light sand
				return(Vector2i(5,5))
				
		return(Vector2i(randi_range(0,4),2))
