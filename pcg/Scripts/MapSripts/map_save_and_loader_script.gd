extends Node
class_name MapSaveAndLoader
@export_category("Save Settings")
var save_directory
var save_directory_folder : String = "Maps"

func SetMapDictionary() -> Dictionary:
	var save_map_dictionary : Dictionary = {}
	var map_info : Dictionary = {}
	

	map_info = {
		"map_name" : "DefaultName",
		"map_chunk_size" : 10,
		"map_seed" : 1234,
		"map_scale" : 1.0	
	}
	
	save_map_dictionary = {
		"map_info" : map_info,
		"save_date" : "1/1/2025"
	}
	return save_map_dictionary
func SaveMap(map_name : String, seed : int):
	var save_dict : Dictionary = SetMapDictionary()
	var save_file = FileAccess.open("user://"+ map_name + ".save", FileAccess.WRITE)
	var save_string  : String = JSON.stringify(save_dict)
	var date : String = Time.get_datetime_string_from_system()
	save_file.store_line(save_string)
	
	pass

func LoadMap(map_name):
	var save_dict : Dictionary 
	if not FileAccess.file_exists("user://" +  map_name + ".save"):
		return # Error! We don't have a save to load.
	var save_file : FileAccess = FileAccess.open("user://" + map_name + ".save", FileAccess.READ)
	var json = JSON.new()
	var s = save_file.get_line()
	
	print(s)
	
	pass


	
func _ready() -> void:
	save_directory = "user://"
	SaveMap("test", 1234)
	LoadMap("test")
	
	
