extends PanelContainer

var map_seed : int = 0
@export var map_seed_inputfield : LineEdit
@export var map_generator : MapGenerator 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_generate_button_pressed() -> void:
	map_generator.RegenerateTerrain(map_seed)
	print("generate")
	pass # Replace with function body.

func _on_generate_random_seed_pressed() -> void:
	var random_seed : int = randi_range(0,9999)
	map_seed = int(random_seed)
	map_seed_inputfield.text = str(random_seed)
	print(map_seed)

func _on_seed_line_edit_text_changed(new_text: String) -> void:
	map_seed = int(new_text)
	print(map_seed)
	pass # Replace with function body.
