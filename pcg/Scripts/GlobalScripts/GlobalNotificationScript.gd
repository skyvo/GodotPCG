extends Node
class_name GlobalNotificationSingleton
var notification_manager : NotificationManager

func NewNotification(text):
	if notification_manager != null:
		notification_manager.AddNotification(text)
	else:
		pass
		
