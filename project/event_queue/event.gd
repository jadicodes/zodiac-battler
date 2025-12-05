class_name Event
extends RefCounted

signal started
signal completed

var _listeners: Array[Object] = []


func start(listener: Object) -> void:
	_listeners.append(listener)

	if _listeners.size() == 1:
		started.emit()


func complete(listener: Object) -> void:
	assert(listener in _listeners)
	
	_listeners.erase(listener)
	
	if _listeners.is_empty():
		completed.emit()
