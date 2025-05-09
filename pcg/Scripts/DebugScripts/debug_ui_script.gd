extends Control
class_name  DebugPanel
#setup variables
@export_group("Setup")
@export var chunk_manager : ChunkManager
@export var fps_label : Label
@export var frametime_label : Label
@export var position_label : Label
@export var zoom_label : Label

@export var debug_toggle_container : Control
@export var debug_profiler_container : Control

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

#camera variables
var current_zoom : Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
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
	
	var current_frame_time : float = Performance.get_monitor(Performance.TIME_PROCESS)
	frametime_label.text = "FRAME TIME: " + str(current_frame_time * 1000) + "ms"
	
	
	
func PositionDebugUI():
	if chunk_manager:
		var new_current_chunk_coordinates : Vector2i = 	chunk_manager.current_visited_chunk_coordinates
		
		if new_current_chunk_coordinates != current_chunk_position:
			current_chunk_position = new_current_chunk_coordinates
			position_label.text = "CHUNK: " + str(current_chunk_position) + " / TILE: "
			
	zoom_label.text = "zoom: " + str(current_zoom.x)	
	pass

func _on_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		debug_toggle_container.visible = true
		chunk_manager.debug_enabled = true
		chunk_manager.UpdateDebugState()
	else:
		debug_toggle_container.visible = false
		chunk_manager.debug_enabled = false
		chunk_manager.UpdateDebugState()
	pass # Replace with function body.


func _on_chunk_grid_check_button_toggled(toggled_on: bool) -> void:
	chunk_manager.debug_enabled = toggled_on
	chunk_manager.UpdateDebugState()
	pass # Replace with function body.


func _on_chunk_bg_button_toggled(toggled_on: bool) -> void:
	chunk_manager.debug_backdrop = toggled_on
	chunk_manager.UpdateDebugState()
	pass # Replace with function body.


func _on_performance_check_button_toggled(toggled_on: bool) -> void:
	debug_profiler_container.visible = toggled_on
	pass # Replace with function body.
