extends Node2D
class_name Chunk

#tilemap variables
var tile_size : int = 16
var chunk_size : int = 50
var chunk_rect: Rect2i
@export var test_tilemap : TileMapLayer
@export var folliage_tilemap : TileMapLayer
var color : Color 

#chunk variables
var chunkCoordinates : Vector2i
var is_active : bool = false

#debug variables
var debug_backdrop : bool = true
var debug_enabled : bool = true
@export var debug_font : Font
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
	
func UpdateChunk():
	if is_active:
		test_tilemap.visible = true
	else:
		test_tilemap.visible = false


#terrain generation
func GenerateTerrain(noise : Noise, mapgenerator : MapGenerator):
	for x in range(-chunk_size/2,chunk_size/2):
		for y in range(-chunk_size/2,chunk_size/2):
			var noise_value = noise.get_noise_2d(x + chunkCoordinates.x*chunk_size,y+ chunkCoordinates.y*chunk_size)
				
			#calculate suitable tile type:
			var tile_atlas : Vector2i = mapgenerator.CalculateCellType(noise_value)
			test_tilemap.set_cell(Vector2i(x,y),1,tile_atlas)
			
func GenerateFolliage(noise : Noise, mapgenerator : MapGenerator):
	#add function to place trees and shit
	pass
	#DEBUG SHIT
func _draw() -> void:
	chunk_rect  = GetChunkRect()
	if debug_enabled:
		draw_rect(chunk_rect,color,false,20,true)
		if debug_backdrop:
			var new_color = color
			new_color.a = 0.2
			draw_rect(chunk_rect,new_color,true,-1,true)
		draw_string(debug_font,Vector2.ZERO, str(chunkCoordinates),HORIZONTAL_ALIGNMENT_CENTER,-1,30,color)
		pass
