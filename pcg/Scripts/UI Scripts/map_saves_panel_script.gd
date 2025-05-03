extends PanelContainer
class_name MapSavesPanel

var  camera_controller : CameraControler

@export_category("Setup")
@export_group("Nodes")
@export var save_element_holder : Control
@export_group("Prefabs")
@export var map_save_file_element : PackedScene

var map_save_and_loader : MapSaveAndLoader
var valid_map_save_files 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UpdateSaveFilesUI()
	pass # Replace with function body.

func UpdateSaveFilesUI():
	if map_save_and_loader != null:
		valid_map_save_files = map_save_and_loader.GetAllMapSaves()

		ClearSaveFileElements()
		for save_file in valid_map_save_files:
			var new_save_element : MapSaveUIElement = map_save_file_element.instantiate()
			save_element_holder.add_child(new_save_element)
			
			
			
			var save_dict : Dictionary = ReadAndSendData(save_file)
			if save_dict.has("map_info"):
				var map_info_dict : Dictionary = save_dict.get("map_info")
				
				if map_info_dict.has("map_name"):
					new_save_element.map_name = map_info_dict.get("map_name")
			if save_dict.has("save_date"):
				new_save_element.save_date = save_dict.get("save_date")
			new_save_element.Initialize()
			new_save_element.DeleteMap.connect(OnSaveDelete.bind(new_save_element.map_name))
			new_save_element.LoadMap.connect(OnSaveLoad.bind(new_save_element.map_name))
func ReadAndSendData(save_file : String):
	var file : FileAccess = FileAccess.open(map_save_and_loader.map_save_directory + "/" + save_file, FileAccess.READ)
	if file != null:
		var json = JSON.new()
		var save_string = file.get_line()
		var dict : Dictionary = map_save_and_loader.LoadMapDictionary(json,save_string)
		if dict != null && dict.size() != 0:
			return dict

func ClearSaveFileElements():
	for element in save_element_holder.get_children():
		element.queue_free()
#signals
func _on_close_button_pressed() -> void:
	camera_controller.input_enabled = true
	visible = false
	pass # Replace with function body.


func _on_refresh_button_pressed() -> void:
	UpdateSaveFilesUI()
	pass # Replace with function body.

func OnSaveDelete(path):
	print("delete")
	DirAccess.remove_absolute(map_save_and_loader.map_save_directory + "/" + path + ".map_save")
	print(map_save_and_loader.map_save_directory + "/" + path)
	UpdateSaveFilesUI()
	pass
	
func OnSaveLoad(path):
	print(path)
	map_save_and_loader.procedural_map_parent.save_manager.LoadMap(path)
	
	pass
