extends CanvasLayer
@export var chunk_manager : ChunkManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug_toggle"):
		if  chunk_manager.debug_enabled == true:
			chunk_manager.debug_enabled = false
			chunk_manager.UpdateDebugState()
		else:
			chunk_manager.debug_enabled = true
			chunk_manager.UpdateDebugState()
	pass
