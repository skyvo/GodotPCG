extends Node2D

@export var chunk : Chunk

func _draw() -> void:
	var rect : Rect2 = chunk.chunk_rect
	draw_rect(rect,Color.WHITE,true)
