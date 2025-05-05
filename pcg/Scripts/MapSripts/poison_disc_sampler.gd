extends Node2D
class_name PoisonDiscSampler
var rect : Rect2 
@export var chunk : Chunk
@export var polygon_2d : Polygon2D
@export var multimesh_2d : MultiMeshInstance2D

@export var test : PackedScene
#polygon points
var UPPER_LEFT : Vector2
var UPPER_RIGHT : Vector2
var DOWN_LEFT : Vector2
var DOWN_RIGHT : Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GeneratePoints()
	pass # Replace with function body.


func SetChunkPolygon():
	polygon_2d.polygon = CalculateChunkBounds()
func CalculateChunkBounds() -> Array[Vector2]:
	var offset : int = (chunk.chunk_size/2) * 16
	UPPER_LEFT = Vector2(-offset,offset)
	UPPER_RIGHT = Vector2(offset,offset)
	DOWN_LEFT = Vector2(-offset,-offset)
	DOWN_RIGHT = Vector2(offset,-offset)
	
	var corners : Array[Vector2] = [UPPER_LEFT,UPPER_RIGHT,DOWN_RIGHT,DOWN_LEFT]
	return corners

func GeneratePoints():
	
	if chunk != null:
		print("works")
		SetChunkPolygon()
		
		
		var points : PackedVector2Array = GlobalPoissonDiscSampler.generate_points_for_polygon(polygon_2d.polygon,100,2,Vector2.ZERO)
		var point_amount : int = points.size()
		multimesh_2d.multimesh.instance_count = point_amount
		

			
			
		for i in multimesh_2d.multimesh.instance_count:
			var angle = PI
			var pos : Vector2 = points[i-1]
			
			
			multimesh_2d.multimesh.set_instance_transform_2d(i, Transform2D(angle, pos))
			print(pos)
	print(multimesh_2d.multimesh.instance_count)
	
	
