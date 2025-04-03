extends Node2D
class_name ChunkManager

@export_category("Chunk Settings")
@export var chunk_prefab : PackedScene = preload("res://chunk.tscn")
@export var chunk_amount : int 
@export var tile_size : int = 16
@export var chunk_size : int = 100

@export_category("Chunk loading Settings")
var chunk_total_size : int = tile_size * chunk_size
var chunk_dictionary : Dictionary [Vector2i,Chunk]
var current_loaded_chunks : Array [Chunk]
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


func _ready() -> void:
	InstantiateChunks()
	current_visited_chunk = chunk_dictionary.get(Vector2i(1,1))
	print(chunk_dictionary.get(Vector2i(1,1)))
	if current_visited_chunk:
		Test()
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
	print(chunk_dictionary.size())
	
func GetNeighbours():
	var neighbours = []
	if chunk_dictionary.get(current_visited_chunk_coordinates):
		
		neighbours.append(Vector2i(current_visited_chunk.chunkCoordinates.x + 1,current_visited_chunk.chunkCoordinates.y))
		neighbours.append(Vector2i(current_visited_chunk.chunkCoordinates.x - 1,current_visited_chunk.chunkCoordinates.y))
		
		neighbours.append(Vector2i(current_visited_chunk.chunkCoordinates.x + 1,current_visited_chunk.chunkCoordinates.y + 1))
		neighbours.append(Vector2i(current_visited_chunk.chunkCoordinates.x - 1,current_visited_chunk.chunkCoordinates.y + 1))
		neighbours.append(Vector2i(current_visited_chunk.chunkCoordinates.x ,current_visited_chunk.chunkCoordinates.y + 1))
		
		neighbours.append(Vector2i(current_visited_chunk.chunkCoordinates.x + 1,current_visited_chunk.chunkCoordinates.y - 1))
		neighbours.append(Vector2i(current_visited_chunk.chunkCoordinates.x - 1,current_visited_chunk.chunkCoordinates.y - 1))
		neighbours.append(Vector2i(current_visited_chunk.chunkCoordinates.x ,current_visited_chunk.chunkCoordinates.y - 1))
		
		#check if these positions are valid, if not, remove them
		for neighbour in neighbours:
			if chunk_dictionary.get(neighbour) == null:
				neighbours.erase(neighbour)
		#return valid neighbours		
		
		return neighbours
	else:
		return neighbours

func Test():
	current_visited_chunk.color = Color.BLUE	
	for i in GetNeighbours():
		if chunk_dictionary.get(i):
			chunk_dictionary.get(i).color = active_chunk_color
	

#chunk loading functions
func GetCameraChunkCoordinates() -> Vector2i:
	var focus_global_position = chunk_focus_point.global_position
	var coordinates = Vector2((focus_global_position.x ) / chunk_total_size ,(focus_global_position.y )/ chunk_total_size)
	# -= chunk_total_size/2
	#coordinates.y -= chunk_total_size/2
	coordinates.x = snapped(coordinates.x,1 )
	coordinates.y = snapped(coordinates.y,1 )
	return coordinates
	
func UpdateVisibleChunks():
	#clear current_chunks
	current_loaded_chunks.clear()
	current_loaded_chunks.append(current_visited_chunk)
	
	#set coordinates
	current_visited_chunk_coordinates = GetCameraChunkCoordinates()
	current_visited_chunk = chunk_dictionary.get(current_visited_chunk_coordinates)
	current_visited_chunk
	#get neigbouring chunks
	for neigbour in GetNeighbours():
		var neigbour_chunk : Chunk = chunk_dictionary.get(neigbour)
		current_loaded_chunks.append(neigbour_chunk)
	
	#set chunk states
	for chunk : Chunk in chunk_dictionary.values():
		#check if chunk is already loaded
		if current_loaded_chunks.has(chunk):
			if chunk.is_active:
				if chunk == current_visited_chunk:
					chunk.color = focus_chunk_color
				else:
					chunk.color = active_chunk_color
				pass
			else:
				#chunk needs to be loaded and set active
				chunk.color = active_chunk_color
				chunk.is_active = true
				chunk.UpdateChunk()
				chunk.GenerateTerrain(map_generator.terrain_noise, map_generator)
				#chunk.visible = true
		else:
			#chunk does not need to be loaded and thus be set inactive
			chunk.color = inactive_chunk_color
			chunk.is_active = false
			chunk.UpdateChunk()
			#chunk.visible = false
		chunk.queue_redraw()	
	
	pass
	
func _on_chunk_timer_timeout() -> void:
	UpdateVisibleChunks()
	pass # Replace with function body.
