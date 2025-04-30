extends Node
class_name GlobalNotificationSingleton
var notification_manager : NotificationManager

func NewNotification(text):
	notification_manager.AddNotification(text)
