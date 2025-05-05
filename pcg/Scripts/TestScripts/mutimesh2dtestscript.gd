extends Node2D

@export var  multimesh2d : MultiMeshInstance2D
var size : int = 100
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var positions : Array[Vector2]
	var i = 0
	multimesh2d.multimesh.instance_count = size * size
	
	for x in randi_range(-size/2, size/2):
		i +=1
		for y in randi_range(-size/2, size/2):
			i +=1
			
			var position_i = Vector2(x * 64,y*64)
			var angle = PI
			print(i,"+", position_i)
			multimesh2d.multimesh.set_instance_transform_2d(i,Transform2D(angle,position_i))	
			
	

	
	
			
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
