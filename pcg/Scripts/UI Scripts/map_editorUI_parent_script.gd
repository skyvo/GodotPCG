extends CanvasLayer

#setup
@export_category("Setup")
@export var procedural_map_parent : ProceduralMapParent
@export var save_and_loader : MapSaveAndLoader
@export var camera_controller : CameraControler

@export_category("Children Setup")
@export var map_generation_panel : MapGenerationPanel
@export var save_and_loader_panel : MapSavesPanel
@export var debug_panel : DebugPanel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	map_generation_panel.camera_controler = camera_controller
	map_generation_panel.procedural_map_parent = procedural_map_parent
	
	save_and_loader_panel.camera_controller = camera_controller
	save_and_loader_panel.map_save_and_loader = save_and_loader
	
	debug_panel.chunk_manager = procedural_map_parent.chunk_manager
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		if visible:
			visible = false
		else:
			visible = true
	debug_panel.current_zoom = camera_controller.camera.zoom
	pass
