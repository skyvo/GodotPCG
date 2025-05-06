extends Node2D

@export var  multimesh2d : MultiMeshInstance2D
var size : int = 50
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var positions : Array[Vector2]
	var i = -1
	multimesh2d.multimesh.instance_count = size * size
	
	var start = Time.get_ticks_msec()
	for x in range(-size/2,size/2):		
		for y in range(-size/2,size/2):
			i +=1
			
			var r : int = randi_range(0,1)
			var position_i = Vector2(x * 16,y*16)
			var angle = PI
			
			multimesh2d.multimesh.set_instance_transform_2d(i,Transform2D(angle,position_i))	
			
			if i < multimesh2d.multimesh.instance_count && i >= 0:
				
				if r == 1:
					multimesh2d.multimesh.set_instance_color(i,Color.RED)
				else:
					multimesh2d.multimesh.set_instance_color(i,Color.GREEN)
			pass
	var end = Time.get_ticks_msec()		
	var time = end - start 
	print(time, "ms")
	
			
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
