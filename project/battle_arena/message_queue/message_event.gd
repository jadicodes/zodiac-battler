class_name MessageEvent
extends Event

var _message: String


func _init(message: String) -> void:
	_message = message


func get_message() -> String:
	return _message
