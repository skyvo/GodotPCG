extends CanvasLayer

func _ready() -> void:
	visible = false
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		if visible:
			visible = false
		else:
			visible = true
	

func _on_quit_game_button_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.


func _on_main_menu_button_pressed() -> void:
	GlobalSceneManagerScript.SwitchScene(GlobalSceneManagerScript.scene_manager.main_menu_scene)
	pass # Replace with function body.


func _on_resume_button_pressed() -> void:
	Input.action_press("escape")
	
	pass # Replace with function body.
