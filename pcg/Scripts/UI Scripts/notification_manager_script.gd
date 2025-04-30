extends Control
class_name NotificationManager

@export var notification_prefab : PackedScene
@export var notifications_holder : Control
var max_notifications : int
var life_time : float = 2.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalNotificationScript.notification_manager = self
	pass # Replace with function body.

func AddNotification(text : String):
	var new_notification : NotificationMessage = notification_prefab.instantiate()
	notifications_holder.add_child(new_notification)
	new_notification.Initialize(text,life_time)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
