extends PanelContainer
class_name MapSaveUIElement

@export_category("SetUp")
@export var map_name_label : Label
@export var save_date_label : Label

var map_name : String
var save_date : String

var save_file_path : String

#signals
signal LoadMap()
signal DeleteMap()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func Initialize() -> void:
	map_name_label.text = map_name
	save_date_label.text = save_date
	pass
	


func _on_delete_button_pressed() -> void:
	DeleteMap.emit()
	pass # Replace with function body.


func _on_load_button_pressed() -> void:
	
	LoadMap.emit()
	pass # Replace with function body.
