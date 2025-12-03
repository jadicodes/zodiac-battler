class_name Event
extends RefCounted

signal started
signal completed


func start() -> void:
	started.emit()


func complete() -> void:
	completed.emit()
