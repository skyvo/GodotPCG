extends PanelContainer
class_name MapSavesPanel

var  camera_controller : CameraControler

@export_category("Setup")
@export_group("Nodes")
@export var save_element_holder : Control
@export_group("Prefabs")
@export var map_save_file_element : PackedScene

var valid_map_save_files : Array [JSON]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func UpdateSaveFilesUI():
	for save_file in valid_map_save_files:
		var new_save_element : MapSaveUIElement = map_save_file_element.instantiate()
		save_element_holder.add_child(new_save_element)
		new_save_element.Initialize()

#signals
func _on_close_button_pressed() -> void:
	camera_controller.input_enabled = true
	visible = false
	pass # Replace with function body.
