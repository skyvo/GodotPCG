extends Camera2D

var strength = .1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("zoom_in"):
		zoom += Vector2(strength,strength)
	if Input.is_action_just_pressed("zoom_out"):
		zoom -= Vector2(strength,strength)	
	pass
