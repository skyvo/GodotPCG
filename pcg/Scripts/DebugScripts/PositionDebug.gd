extends Label
@export var chunk_manager : ChunkManager

var focus_coordinates
var focus_global_position
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	focus_coordinates = chunk_manager.current_visited_chunk_coordinates
	focus_global_position = chunk_manager.chunk_focus_point.global_position
	
	text = "GLOBAL: " + str(focus_global_position.round()) + "  // COORDINATES: " + str(focus_coordinates)
	pass
