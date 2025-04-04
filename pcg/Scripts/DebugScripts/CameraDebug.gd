extends Label
@export var camera : Camera2D
var current_zoom 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	current_zoom = camera.zoom
	text = "zoom: " + str(current_zoom.x)
	pass
