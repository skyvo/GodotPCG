extends Node
class_name ProceduralMapParent
#setup
@export_category("Managers")
@export var map_generator : MapGenerator
@export var chunk_manager : ChunkManager
@export var save_manager : MapSaveAndLoader

signal map_data_loaded
signal map_saved 
signal map_regenerated


	


func _on_map_data_loaded(save_map_data: Dictionary) -> void:
	map_generator.LoadMap(save_map_data)
	pass # Replace with function body.
