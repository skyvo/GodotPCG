extends Node


var scene_manager : SceneManager

func SwitchScene(scene : PackedScene):
	#check if scene manager exists
	if scene_manager != null:
		scene_manager.SwitchScene(scene)
