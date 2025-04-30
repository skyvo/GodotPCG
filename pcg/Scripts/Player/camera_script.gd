extends Node2D
@onready var camera : Camera2D = self.get_child(0)

@export_category("camera settings")
@export_group("movement")
@export var movement_speed:float = 10
var move_direction:float = 0

@export_group("zoom")
@export var zoom_speed:float = 2
var zoom_direction:float = 0
var current_zoom 
@export_range(0,10)var min_zoom = 0.111
@export_range(1,10)var max_zoom = 3
@export var camera_zoom_speed_damp = .92

@export_group("pan")
@export var pan_speed:float = 200
@export var pan_margin:float = 60
var pan_direction:float = 0

@export var chunk_manager : ChunkManager
#flags
var can_move = true
@export var can_pan = true
var is_panning = true
# Called when the node enters the scene tree for the first time.
func _ready():
	current_zoom = camera.zoom.x
	PositionConstraint()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	camera_movement(delta)
	camera_pan(delta)
	camera_zoom(delta)
	PositionConstraint()
	pass

func _unhandled_input(event):
	if event.is_action("zoom_in"):
		zoom_direction =1
		
	elif event.is_action("zoom_out"):
		zoom_direction = -1
	pass
		
func camera_movement(delta) ->void:
	if !can_move: 
		return
	var move_dir = Vector2.ZERO
	
	if Input.is_action_pressed("camera_move_right"): move_dir.x = 1	
	if Input.is_action_pressed("camera_move_left"): move_dir.x = -1	
	if Input.is_action_pressed("camera_move_up"): move_dir.y = -1	
	if Input.is_action_pressed("camera_move_down"): move_dir.y = 1
	
	position += delta * (movement_speed / current_zoom ) * move_dir.normalized()
	
func camera_pan(delta) ->void:
	if !can_pan or !is_panning:return
	
	var viewport_current:Viewport = get_viewport()
	var pan_direction:Vector2 = Vector2(-1,-1)
	var viewport_visible_rectangle:Rect2i = Rect2(viewport_current.get_visible_rect())
	var viewport_size:Vector2i = viewport_visible_rectangle.size
	var current_mouse_pos:Vector2 = viewport_current.get_mouse_position()
	var margin:float = pan_margin
	
	if((current_mouse_pos.x < margin) or (current_mouse_pos.x >viewport_size.x)):
		if current_mouse_pos.x > viewport_size.x/2:
			pan_direction.x = 1
		translate(Vector2(pan_direction.x * delta * (pan_speed / current_zoom), 0))
	# pan Y
	if((current_mouse_pos.y < margin) or (current_mouse_pos.y >viewport_size.y)):
		if current_mouse_pos.y > viewport_size.x/2:
			pan_direction.y = 1
		translate(Vector2(0, pan_direction.y * delta * (pan_speed / current_zoom)))

func camera_zoom(delta):
	current_zoom = camera.zoom.x
	var new_zoom:float = clamp(camera.zoom.x + zoom_speed *  zoom_direction * delta, min_zoom, max_zoom)
	zoom_direction *= camera_zoom_speed_damp
	camera.zoom = Vector2(new_zoom, new_zoom)
	pass

func PositionConstraint():
	var limit : int = (chunk_manager.chunk_amount/2)*(chunk_manager.chunk_size)*(chunk_manager.tile_size)
	global_position.clamp(Vector2(-limit,-limit),Vector2(limit,limit))
	
