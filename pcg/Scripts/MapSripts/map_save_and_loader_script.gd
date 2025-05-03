extends Node
class_name MapSaveAndLoader

@export var procedural_map_parent : ProceduralMapParent
@export_category("Save Settings")
var save_directory
var save_directory_folder : String = "Maps"

signal MapDataLoaded(save_map_data : Dictionary)

func _ready() -> void:
	save_directory = "user://"
	SaveMap("test")
	LoadMap("test")
	
func SaveMap(map_name : String):
	var save_dict : Dictionary = SetMapDictionary()
	var save_file = FileAccess.open("user://"+ map_name + ".map_save", FileAccess.WRITE)
	var save_string  : String = JSON.stringify(save_dict)
	var date : String = Time.get_datetime_string_from_system()
	save_file.store_line(save_string)
	pass

func LoadMap(map_name):
	var save_dict : Dictionary 
	if not FileAccess.file_exists("user://" +  map_name + ".save"):
		return # Error! We don't have a save to load.
	var save_file : FileAccess = FileAccess.open("user://" + map_name + ".map_save", FileAccess.READ)
	var json = JSON.new()
	var map_data_string = save_file.get_line()
	var save_map_dictionary : Dictionary = LoadMapDictionary(json,map_data_string)
	if save_map_dictionary == null:
		pass
	else:
		MapDataLoaded.emit(save_map_dictionary)

func SetMapDictionary() -> Dictionary:
	var save_map_dictionary : Dictionary = {}
	var map_info : Dictionary = {}
	var date : String = Time.get_datetime_string_from_system()

	map_info = {
		"map_name" : procedural_map_parent.map_generator.map_name,
		"map_chunk_size" : procedural_map_parent.chunk_manager.chunk_amount,
		"map_seed" : procedural_map_parent.map_generator.terrain_noise.seed,
		"map_scale" : 1.0,	
		"water_level" : procedural_map_parent.map_generator.water_level
	}
	
	save_map_dictionary = {
		"map_info" : map_info,
		"save_date" : date
	}
	return save_map_dictionary
	
func LoadMapDictionary(json : JSON, save_map_string : String) -> Dictionary:
	var save_map_dictionary : Dictionary
	
	#check errors
	var error = json.parse(save_map_string)
	if error == OK:
		var data_received = json.data
		if typeof(data_received) == TYPE_DICTIONARY:
			print("MAP DATA:")
			print(data_received)
			save_map_dictionary = data_received
		else:
			print("unexpected data")
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", save_map_string, " at line ", json.get_error_line())
	return save_map_dictionary

	
	
	
