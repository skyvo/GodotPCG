extends Label
class_name  NotificationMessage

@export var life_time_timer : Timer 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.

func Initialize(new_text : String, life_time : float):
	text = new_text
	life_time_timer.wait_time = life_time
	life_time_timer.start()
	var tween : Tween = get_tree().create_tween()
	tween.set_ease( Tween.EASE_OUT) 
	tween.tween_property(self,"modulate:a",0,life_time)
	
	await life_time_timer.timeout
	tween.kill()
	
func _on_lifetime_timer_timeout() -> void:
	queue_free()
	pass # Replace with function body.
