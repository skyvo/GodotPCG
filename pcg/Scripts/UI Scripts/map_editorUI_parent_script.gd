extends CanvasLayer

#setup
@export_category("Setup")
@export var procedural_map_parent : ProceduralMapParent
@export var save_and_loader : MapSaveAndLoader
@export var camera_controller : CameraControler

@export_category("Children Setup")
@export var map_generation_panel : MapGenerationPanel
@export var save_and_loader_panel : MapSavesPanel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	map_generation_panel.camera_controler = camera_controller
	map_generation_panel.procedural_map_parent = procedural_map_parent
	
	save_and_loader_panel.camera_controller = camera_controller
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
