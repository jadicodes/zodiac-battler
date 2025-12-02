class_name Event
extends Node

signal started
signal completed


func start() -> void:
	started.emit()


func complete() -> void:
	completed.emit()
