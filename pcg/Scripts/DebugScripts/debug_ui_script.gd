extends CanvasLayer

#setup variables
@export_group("Setup")
@export var chunk_manager : ChunkManager
@export var fps_label : Label
@export var frametime_label : Label
@export var position_label : Label
#profiling variables
@export_group("ProfilingUI")
@export var show_profiler_ui : bool = true
var fps : int
var max_fps : int = 0
var min_fps : int = 0
var frametime : float 
var max_frametime : float
#position variables
var current_chunk_position : Vector2i
var current_tile_position : Vector2i
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	InputHandler()
	if show_profiler_ui:
		ProfilingDebugUI()
	PositionDebugUI()
	pass

func InputHandler():
	if !chunk_manager:
		return
	if Input.is_action_just_pressed("debug_toggle"):
		if  chunk_manager.debug_enabled == true:
			chunk_manager.debug_enabled = false
			chunk_manager.UpdateDebugState()
		else:
			chunk_manager.debug_enabled = true
			chunk_manager.UpdateDebugState()
	if Input.is_action_just_pressed("select"):
		pass
		#build
	pass
	
func ProfilingDebugUI():
	var current_fps : int = Engine.get_frames_per_second()
	if current_fps != fps:
		if current_fps > max_fps:
			max_fps = current_fps
		elif current_fps < min_fps:
			min_fps = current_fps
		fps_label.text = "FPS: " + str(current_fps) + " / MIN: " + str(min_fps) + " MAX: " + str(max_fps) 
	
	
func PositionDebugUI():
	if chunk_manager:
		var new_current_chunk_coordinates : Vector2i = 	chunk_manager.current_visited_chunk_coordinates
		
		if new_current_chunk_coordinates != current_chunk_position:
			current_chunk_position = new_current_chunk_coordinates
			position_label.text = "CHUNK: " + str(current_chunk_position) + " / TILE: " + str("coming soon lol")
			
		
	pass
