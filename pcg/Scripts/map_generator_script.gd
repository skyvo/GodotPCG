
extends Node
class_name MapGenerator

@export_group("Set Up")
@export var chunk_manager : ChunkManager
var terrain_noise : Noise 
var folliage_noise : Noise 
var offset_terrain_noise : Noise

@export_category("Map Settings")
@export var water_level : float = 0.0

@export_group("Noise Textures")
@export var terrain_noise_texture : NoiseTexture2D
@export var offset_terrain_noise_texture : NoiseTexture2D
@export var fertility_noise_texture : NoiseTexture2D

@export_category("tresholds")
@export_group("Terrain tresholds")
@export var terrain_ramp : Gradient
@export var terrain_water_ramp : Gradient
var tressholds_offsets : Array [float]
var water_tressholds_offsets : Array [float]
#adjusted tressholds to noise values
var adjusted_tressholds_offsets : Array [float]
var tressholds_colors : Array [Color]
#terrain tresshold values

@export_subgroup("Terrain tresholds", "Values")
@export var deep_water_resshold : float
@export var normal_water_tresshold : float
@export var shallow_water_tresshold : float
@export var light_sand_tresshold : float
@export var dark_sand_tresshold : float
@export var light_grass_tresshold : float
@export var dark_grass_tresshold : float
@export var light_rock_tresshold : float
@export var dark_rock_tresshold : float
@export var snow_tresshold : float
#terrain tresshold colors
@export_subgroup("Terrain tresholds", "Colors")
@export var light_sand_tresshold_color : Color
@export var dark_sand_tresshold_color : Color
@export var light_grass_tresshold_color : Color
@export var dark_grass_tresshold_color : Color
@export var light_rock_tresshold_color : Color
@export var dark_rock_tresshold_color : Color
@export var snow_tresshold_color : Color
# adjusted treshold values
var adjusted_light_sand_tresshold : float
var adjusted_dark_sand_tresshold : float
var adjusted_light_grass_tresshold : float
var adjusted_dark_grass_tresshold : float
var adjusted_light_rock_tresshold : float
var adjusted_dark_rock_tresshold : float
var adjusted_snow_tresshold : float


func _ready() -> void:
	SetNoise()
	SetTresholds()
	CalculateAdjustedTresholds(tressholds_offsets,terrain_noise)
	chunk_manager.InstantiateChunks()
	chunk_manager.current_visited_chunk = chunk_manager.chunk_dictionary.get(Vector2i(1,1))
	chunk_manager.UpdateDebugState()
	
	pass # Replace with function body.

#function to set seed
func SetSeed(new_seed):
	terrain_noise.seed = new_seed
	folliage_noise.seed = new_seed
	offset_terrain_noise.seed = new_seed
	SetNoise()
	
#function to get noise from textures
func SetNoise():
	terrain_noise = terrain_noise_texture.noise
	folliage_noise = fertility_noise_texture.noise
	offset_terrain_noise = offset_terrain_noise_texture.noise
	
#function to regenerate map via chunkmanager
func RegenerateTerrain(seed : int):
	var start : float = Time.get_ticks_msec()
	SetSeed(seed)
	chunk_manager.RegenerateChunks()
	var end : float = Time.get_ticks_msec()
	print("terrain generated in : ",end - start ,"ms")
	
	#notification
	GlobalNotificationScript.NewNotification("MAP GENERATED" + ("in : "+ str(end - start) + "ms"))
#function to get the corresponding tile atlas for the given noise value
func CalculateTerrainCellType(noise_value) -> Vector2i:
	if noise_value <= water_level:
		#its water
		if noise_value <= water_level + shallow_water_tresshold:
			if noise_value >= water_level + normal_water_tresshold:
				#normal water
				return(Vector2i(3,3))
			else:
				#deep water
				return(Vector2i(4,3))
		else:
			#shallow water
			return(Vector2i(2,3))
	else:
		#its not water
		if noise_value > adjusted_dark_sand_tresshold:
			if noise_value >= adjusted_light_grass_tresshold:
				if noise_value >= adjusted_dark_grass_tresshold:
					if noise_value >= adjusted_light_rock_tresshold:
						if noise_value >= adjusted_dark_rock_tresshold:
							if noise_value >= adjusted_snow_tresshold:
								#snow
								return(Vector2i(4,4))
							#dark rock
							return(Vector2i(3,2))
						#light rock
						return(Vector2i(2,2))
					#dark_grass
					return(Vector2i(3,1))
				#light_grass
				return(Vector2i(2,1))
			#dark sand 
			return(Vector2i(1,0))
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
		if terrain_noise_value > adjusted_dark_sand_tresshold:
			if terrain_noise_value >= adjusted_light_grass_tresshold:
				if terrain_noise_value >= adjusted_dark_grass_tresshold:
					if terrain_noise_value >= adjusted_light_rock_tresshold:
						if terrain_noise_value >= adjusted_dark_rock_tresshold:
							if terrain_noise_value >= adjusted_snow_tresshold:
								#snow
								return(Vector2i(5,5))
							#dark rock
							return(Vector2i(5,5))
						#light rock
						return(Vector2i(5,5))
					#dark_grass
					return(Vector2i(randi_range(0,2),0))
				#light_grass
				return(Vector2i(randi_range(0,2),0))
			#dark sand 
			return(Vector2i(randi_range(0,2),2))
		#light sand
		return(Vector2i(5,5))
		

func CalculateGroundFolliageType(folliage_noise_value, terrain_noise_value) -> Vector2i:
	if terrain_noise_value <= water_level:
		#its water
		if terrain_noise_value <= water_level - 0.2:
			if terrain_noise_value <= water_level - 0.3:
				#normal water
				return(Vector2i(randi_range(0,4),0))
				return(Vector2i(5,5))
			else:
				#deep water
				return(Vector2i(5,5))
		else:
			#shallow water
			return(Vector2i(randi_range(0,4),1))
			
	else:
		var random_number : int = randi_range(0,10)
		#its not water
		if terrain_noise_value > adjusted_dark_sand_tresshold:
			if terrain_noise_value >= adjusted_light_grass_tresshold:
				if terrain_noise_value >= adjusted_dark_grass_tresshold:
					if terrain_noise_value >= adjusted_light_rock_tresshold:
						if terrain_noise_value >= adjusted_dark_rock_tresshold:
							if terrain_noise_value >= adjusted_snow_tresshold:
								#snow
								return(Vector2i(4,5))
							#dark rock
							return(Vector2i(5,5))
						#light rock
						return(Vector2i(5,5))
					#dark_grass
					return(Vector2i(randi_range(2,4),randi_range(0,2)))
				#light_grass
				if random_number > 8:
						if random_number > 7:
							if random_number > 9:
								return(Vector2i(randi_range(0,4),0))
							else:
								return(Vector2i(randi_range(0,4),1))
						return(Vector2i(randi_range(0,4),1))
				return(Vector2i(randi_range(0,4),1))
			#dark sand 
			if folliage_noise_value > -0.35:
				return(Vector2i(randi_range(0,4),3))
			else:
				return(Vector2i(5,5))
		#light sand
		return(Vector2i(randi_range(0,4),3))	
#offset calculator
func CalculateNoiseWithOffset(terrain_noise_value, terrain_offset_noise_value)-> float:
	var new_noise_value = terrain_noise_value + terrain_offset_noise_value
	new_noise_value = new_noise_value / 2 
	
	return new_noise_value

#color_ramp_functions TO DO 
func SetTresholds():
	#create array of tressholds
	tressholds_offsets.clear()
	tressholds_offsets.append(light_sand_tresshold) 
	tressholds_offsets.append(dark_sand_tresshold)
	tressholds_offsets.append(light_grass_tresshold)
	tressholds_offsets.append(dark_grass_tresshold)
	tressholds_offsets.append(light_rock_tresshold)
	tressholds_offsets.append(dark_rock_tresshold)
	tressholds_offsets.append(snow_tresshold)
	
	tressholds_colors.clear()
	tressholds_colors.append(light_sand_tresshold_color)
	tressholds_colors.append(dark_sand_tresshold_color)
	tressholds_colors.append(light_grass_tresshold_color)
	tressholds_colors.append(dark_grass_tresshold_color)
	tressholds_colors.append(light_rock_tresshold_color)
	tressholds_colors.append(dark_rock_tresshold_color)
	tressholds_colors.append(snow_tresshold_color)
	
	for i in terrain_ramp.offsets.size():
		terrain_ramp.offsets[i] = tressholds_offsets[i]
		terrain_ramp.colors[i]  = tressholds_colors [i]
		pass


func CalculateAdjustedTresholds(tresholds : Array, noise : Noise):
	var adjusted_tresholds : Array [float] 
	#first calculate the min and max
	var min : float
	var max : float
	for x in range(-30,30):
		for y in range(-30,30):
			var value =  noise.get_noise_2d(x*5,y*5)
			if value > max:
				max = value
			elif value < min:
				min = value
	for treshold in tresholds.size():
		var t : float = tresholds[treshold]			
		var adjusted_value : float = (t * max) + water_level
		adjusted_tresholds.append(adjusted_value)
	adjusted_tressholds_offsets = adjusted_tresholds
	
	adjusted_light_sand_tresshold = adjusted_tresholds[0]
	adjusted_dark_sand_tresshold = adjusted_tresholds[1]
	adjusted_light_grass_tresshold = adjusted_tresholds[2]
	adjusted_dark_grass_tresshold = adjusted_tresholds[3]
	adjusted_light_rock_tresshold = adjusted_tresholds[4]
	adjusted_dark_rock_tresshold = adjusted_tresholds[5]
	adjusted_snow_tresshold = adjusted_tresholds[6]
	
#editor tool
func on_gradient_bool_chage(value: bool):
	SetTresholds()
