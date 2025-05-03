extends CanvasLayer

func LoadMapCreator():
	print("o")
	GlobalSceneManagerScript.SwitchScene(GlobalSceneManagerScript.scene_manager.map_creator_scene)
	print(GlobalSceneManagerScript.scene_manager.map_creator_scene)
	pass


func _on_map_creater_button_pressed() -> void:
	LoadMapCreator()
	pass # Replace with function body.
