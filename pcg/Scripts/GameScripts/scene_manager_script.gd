extends Node
class_name SceneManager

@export_category("Setup")
@export var main_node : Node
@export var default_scene : Node

@export_category("Scenes")
@export var main_menu_scene : PackedScene
@export var map_creator_scene : PackedScene

var current_active_scene : Node

func _ready() -> void:
	GlobalSceneManagerScript.scene_manager = self
	current_active_scene = default_scene
	
func SwitchScene(desired_scene : PackedScene):
	
	if desired_scene is PackedScene:
		current_active_scene.queue_free()
		var new_scene : Node = desired_scene.instantiate()
		main_node.add_child(new_scene)
		current_active_scene = current_active_scene
	
		print("scene switched to ", new_scene)
	pass
