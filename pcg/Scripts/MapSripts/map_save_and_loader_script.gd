extends Node
class_name MapSaveAndLoader

@export var procedural_map_parent : ProceduralMapParent
@export_category("Save Settings")
@export var save_directory_folder_name : String = "Maps"
var game_folder_name : String = "Argos"
var map_save_directory


signal MapDataLoaded(save_map_data : Dictionary)

func _ready() -> void:
	map_save_directory = GetMapSaveDirectory()
	GetAllMapSaves()
	
	SaveMap("test")
	LoadMap("test")
	
func SaveMap(map_name : String):
	var save_dict : Dictionary = SetMapDictionary()
	var save_file = FileAccess.open(map_save_directory + "/"  + map_name + ".map_save", FileAccess.WRITE)
	var save_string  : String = JSON.stringify(save_dict)
	var date : String = Time.get_datetime_string_from_system()
	save_file.store_line(save_string)
	pass

func LoadMap(map_name):
	print("test")
	var save_dict : Dictionary 
	if not FileAccess.file_exists(map_save_directory +  "/" + map_name + ".map_save"):
		print("file does not exist")
		return # Error! We don't have a save to load.
	var save_file : FileAccess = FileAccess.open(map_save_directory + "/" + map_name + ".map_save", FileAccess.READ)
	var json = JSON.new()
	var map_data_string = save_file.get_line()
	var save_map_dictionary : Dictionary = LoadMapDictionary(json,map_data_string)
	print(save_file)
	if save_map_dictionary == null:
		print("no dictionary")
		pass
	else:
		print("dit werkt")
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
			
			save_map_dictionary = data_received
		else:
			print("unexpected data")
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", save_map_string, " at line ", json.get_error_line())
	return save_map_dictionary

# check if map save folder exist, otherwise create it
func GetMapSaveDirectory():
	var path = OS.get_environment("USERPROFILE") + "/Desktop/" + game_folder_name + "/" + save_directory_folder_name	
	DirAccess.make_dir_recursive_absolute(path)
	return path

# return all map files
func GetAllMapSaves():
	var files : Array 
	files = DirAccess.get_files_at(map_save_directory)
	print(files.size() , " files")
	return files
