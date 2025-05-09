extends Node2D
class_name Chunk

#tilemap variables
var tile_size : int = 16
var chunk_size : int = 50
var chunk_rect: Rect2i

@export_category("Tilemap Layers")
@export var terrain_tilemap : TileMapLayer
@export var folliage_tilemap : TileMapLayer
@export var ground_folliage_tilemap : TileMapLayer

@export_category("Overlay Meshes")
@export var fertility_overlay_mesh : Node2D
@export var fog : Control
@export var grid : Control

@export_category("TextureLayers")
@export var water_layer : WaterLayer
var color : Color 

#chunk variables
var chunkCoordinates : Vector2i
var is_active : bool = false

#debug variables
var debug_backdrop : bool = true
var debug_enabled : bool = true
@export_category("Debug")
@export var debug_font : Font

@export var posion_disc_sampler : PoisonDiscSampler
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	chunk_rect.size = chunk_rect.size - Vector2i(16,16)
	water_layer.chunk = self
	queue_redraw()
	pass # Replace with function body.

func GetChunkRect():
	var chunk_total_size : int = tile_size * chunk_size
	#left
	var l : Vector2i = Vector2i(-chunk_total_size/2,-chunk_total_size/2)
	#right
	var r : Vector2i = Vector2i(chunk_total_size/2, chunk_total_size/2)
	
	#set rect vars
	var rect : Rect2i
	rect.position = l
	rect.end = r
	rect.size = Vector2i(chunk_total_size,chunk_total_size)
	
	return rect
func SetLOD(desired_lod : int):
	match desired_lod:
		0 : ground_folliage_tilemap.visible = false ; folliage_tilemap.visible = false ; grid.visible = false
		1 : ground_folliage_tilemap.visible = false ; folliage_tilemap.visible = true ;grid.visible = false
		2 : ground_folliage_tilemap.visible = true ; folliage_tilemap.visible = true ; grid.visible = true
func UpdateChunk():
	if is_active:
		set_process(true)
		visible = true

	else:
		visible = false
		set_process(false)
		
func GenerateTilemap(fertility_noise : Noise, offset_terrain_noise : Noise, terrain_noise, mapgenerator : MapGenerator):
	var max_terrain : float
	var min_terrain : float
	var max_folliage : float
	var min_folliage : float
	
	for x in range((-chunk_size/2) - 1 ,(chunk_size/2)+1):
		for y in range((-chunk_size/2) - 1 ,(chunk_size/2)+1):
			
			
			var terrain_noise_value = terrain_noise.get_noise_2d(x + chunkCoordinates.x*chunk_size,y+ chunkCoordinates.y*chunk_size)
			var fertility_noise_value = fertility_noise.get_noise_2d(x + chunkCoordinates.x*chunk_size,y+ chunkCoordinates.y*chunk_size)
			var offset_terrain_noise_value = offset_terrain_noise.get_noise_2d(x + chunkCoordinates.x*chunk_size,y+ chunkCoordinates.y*chunk_size)
			#offset
			var new_terrain_noise_value = mapgenerator.CalculateNoiseWithOffset(terrain_noise_value,offset_terrain_noise_value)
			
			var terrain_atlas : Vector2i = mapgenerator.CalculateTerrainCellType(new_terrain_noise_value)
			var folliage_atlas : Vector2i = mapgenerator.CalculateFolliageCellType(fertility_noise_value,new_terrain_noise_value)
			var ground_folliage_atlas : Vector2i = mapgenerator.CalculateGroundFolliageType(fertility_noise_value,new_terrain_noise_value)
			
			#calculate min and max values
			#if terrain_noise_value > max_terrain:
				#max_terrain = terrain_noise_value
			#if terrain_noise_value < min_terrain:
				#min_terrain = terrain_noise_value
			#if fertility_noise_value > max_folliage:
				#max_folliage = fertility_noise_value
			#if fertility_noise_value < min_folliage:
				#min_folliage = fertility_noise_value
			
			terrain_tilemap.set_cell(Vector2i(x,y),1,terrain_atlas)
			if !CheckIfOverdrawTile(x,y):
				var r = randi_range(0,10)
				if fertility_noise_value > -0.32:
					if folliage_atlas != Vector2i(5,5):
						folliage_tilemap.set_cell(Vector2i(x,y),0,folliage_atlas)
				if fertility_noise_value > -0.41:
					if folliage_atlas != Vector2i(5,5):
						ground_folliage_tilemap.set_cell(Vector2i(x,y),0,ground_folliage_atlas)	
			
				
	#print("folliage MINMAX : ", min_folliage, "/",max_folliage)
	
func Clear():
	terrain_tilemap.clear()
	folliage_tilemap.clear()
	ground_folliage_tilemap.clear()			
	#print(min ," : " , max)		
func _draw() -> void:
	chunk_rect  = GetChunkRect()
	if debug_enabled:
		draw_rect(chunk_rect,color,false,20,true)
		if debug_backdrop:
			var new_color = color
			new_color.a = 0.2
			draw_rect(chunk_rect,new_color,true,-1,true)
		draw_string(debug_font,Vector2.ZERO, str(chunkCoordinates),HORIZONTAL_ALIGNMENT_CENTER,-1,70,color)
		pass

func CheckIfOverdrawTile(x : int,y : int) -> bool:
	if x == (chunk_size/2) + 1 &&  x == (-chunk_size/2) - 1:
		return true
		
	if y == (chunk_size/2) + 1 or y == (-chunk_size/2 )- 1:
		return true
	return false			
