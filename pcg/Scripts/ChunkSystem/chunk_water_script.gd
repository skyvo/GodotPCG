extends Node2D

class_name WaterLayer
@export_category("Water Settings")
@export var water_color : Color
@export_range(0,1,0.1) var water_opacity : float

var chunk : Chunk

func _draw() -> void:
	var rect : Rect2 = chunk.chunk_rect
	water_color.a = water_opacity
	draw_rect(rect,water_color,true)
