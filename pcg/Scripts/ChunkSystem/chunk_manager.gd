extends Node2D
class_name ChunkManager

@export_category("Chunk Settings")
@export var chunk_prefab : PackedScene 
@export var chunk_amount : int 
@export var tile_size : int = 16
@export var chunk_size : int = 50

@export_category("Chunk loading Settings")
#total chunk width in pixels
var chunk_total_size : int = tile_size * chunk_size
var chunk_dictionary : Dictionary [Vector2i,Chunk]
var current_loaded_chunks : Array [Chunk]
var current_generated_chunks : Array [Chunk]

var current_visited_chunk : Chunk
var current_visited_chunk_coordinates : Vector2i
@export var chunk_loading_range : int = 2
@export var chunk_timer : Timer
@export var chunk_focus_point : Node2D
@export var map_generator : MapGenerator

@export_category("Debug Settings")
@export var debug_enabled : bool = true
@export var active_chunk_color : Color = Color.GREEN
@export var inactive_chunk_color : Color = Color.RED
@export var focus_chunk_color : Color = Color.BLUE
@export var debug_backdrop : bool = true
@export var debug_outer_edge : bool = true

#LOD SYSTEM
@export_category("LOD System")
@export var current_LOD : int = 1
var min_LOD : int = 1
var max_LOD : int = 3

func _ready() -> void:
	
	pass
	
func InstantiateChunks():
	for x in chunk_amount:
		for y in chunk_amount:
			var new_chunk : Chunk
			new_chunk = chunk_prefab.instantiate()
			new_chunk.chunkCoordinates = Vector2i( x - chunk_amount/2, y - chunk_amount/2)
			new_chunk.name = "Chunk" + str(new_chunk.chunkCoordinates)
			
			add_child(new_chunk)
			
			#sets position in the center 
			new_chunk.position.x = (0 + x * chunk_total_size) - ((chunk_amount * chunk_total_size)/2)
			new_chunk.position.y = (0 + y * chunk_total_size)- ((chunk_amount * chunk_total_size)/2)
			
			new_chunk.is_active = false
			new_chunk.color = inactive_chunk_color
			chunk_dictionary.get_or_add(new_chunk.chunkCoordinates, new_chunk)
			
			#debugshit
			new_chunk.debug_backdrop = debug_backdrop
func RegenerateChunks():
	current_generated_chunks.clear()
	for chunk in chunk_dictionary.values():
		chunk.Clear()
	UpdateVisibleChunks()
func GetNeighbours(chunk_coordinates : Vector2i):
	var neighbours = []
	if chunk_dictionary.get(current_visited_chunk_coordinates):
		
		neighbours.append(Vector2i(chunk_coordinates.x + 1,chunk_coordinates.y))
		neighbours.append(Vector2i(chunk_coordinates.x - 1,chunk_coordinates.y))
		
		neighbours.append(Vector2i(chunk_coordinates.x + 1,chunk_coordinates.y + 1))
		neighbours.append(Vector2i(chunk_coordinates.x - 1,chunk_coordinates.y + 1))
		neighbours.append(Vector2i(chunk_coordinates.x ,chunk_coordinates.y + 1))
		
		neighbours.append(Vector2i(chunk_coordinates.x + 1,chunk_coordinates.y - 1))
		neighbours.append(Vector2i(chunk_coordinates.x - 1,chunk_coordinates.y - 1))
		neighbours.append(Vector2i(chunk_coordinates.x ,chunk_coordinates.y - 1))
		
		#check if these positions are valid, if not, remove them
		for neighbour in neighbours:
			if chunk_dictionary.get(neighbour) == null:
				neighbours.erase(neighbour)
		#return valid neighbours		
		
		return neighbours
	else:
		return neighbours


#chunk loading functions
func GetChunkCoordinates(point_global_position) -> Vector2i:
	var focus_global_position = point_global_position
	var coordinates = Vector2((focus_global_position.x ) / chunk_total_size ,(focus_global_position.y )/ chunk_total_size)
	coordinates.x = snapped(coordinates.x,1 )
	coordinates.y = snapped(coordinates.y,1 )
	return coordinates

func GetTileAtPosition(point_global_position):
	var point_chunk_coordinates = GetChunkCoordinates(point_global_position)
	var point_chunk : Chunk = chunk_dictionary.get(point_chunk_coordinates)
	if point_chunk:
		var tile_coordinates : Vector2 = point_chunk.terrain_tilemap.local_to_map(point_global_position)
		return tile_coordinates
	return
	
func UpdateVisibleChunks():
	UpdateChunkLOD(current_LOD)
	#profiler shit
	var start = Time.get_ticks_usec()
	
	#set coordinates
	current_visited_chunk_coordinates = GetChunkCoordinates(chunk_focus_point.global_position)
	current_visited_chunk = chunk_dictionary.get(current_visited_chunk_coordinates)
	
	if !current_visited_chunk:
		return
	for chunk : Chunk in chunk_dictionary.values():
		if GetValidChunks().has(chunk):
			if chunk == current_visited_chunk:
				chunk.color = focus_chunk_color
			else:
				chunk.color = active_chunk_color
			chunk.is_active = true
			chunk.UpdateChunk()
			if !current_generated_chunks.has(chunk):
					chunk.GenerateTilemap(map_generator.folliage_noise, map_generator.offset_terrain_noise,map_generator.terrain_noise,map_generator)
					current_generated_chunks.append(chunk)
		else:
			chunk.is_active = false
			chunk.UpdateChunk()
			#chunk does not need to be loaded and thus qbe set inactive
			current_loaded_chunks.erase(chunk)
			chunk.color = inactive_chunk_color

		chunk.queue_redraw()	
	
	
	pass

func GetValidChunks() -> Array [Chunk]:
	var valid_chunks : Array [Chunk]
	valid_chunks.append(current_visited_chunk)
	for n in GetNeighbours(current_visited_chunk.chunkCoordinates):
		valid_chunks.append(chunk_dictionary.get(n))
	current_loaded_chunks = valid_chunks
	return valid_chunks
#debug handler
func UpdateDebugState():
	for chunk : Chunk in chunk_dictionary.values():
		chunk.debug_enabled = debug_enabled
		chunk.debug_backdrop = debug_backdrop
		queue_redraw()
	queue_redraw()	
	
func UpdateChunkLOD(new_lod):
	current_LOD = new_lod
	print("hmmmm")
	print(current_loaded_chunks.size())
	for chunk in current_generated_chunks:
		print("changed_lod")
		chunk.SetLOD(new_lod)
		
func _on_chunk_timer_timeout() -> void:
	UpdateVisibleChunks()
	GetTileAtPosition(get_global_mouse_position())
	pass # Replace with function body.
