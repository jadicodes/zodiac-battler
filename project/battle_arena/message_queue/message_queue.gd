class_name MessageQueue
extends Node

signal queue_depleted
signal message_started(message: Message)
signal message_skipped
signal message_ended(message: Message)

var _messages: Array[Message] = []
var _current_message: Message


func add_message(message: Message) -> void:
	_messages.append(message)
	if _current_message == null:
		advance()


func advance() -> void:
	if _current_message:
		message_skipped.emit()
		return

	if _messages.is_empty():
		return

	_current_message = _messages.pop_front()
	message_started.emit(_current_message)


func _on_message_ended() -> void:
	message_ended.emit(_current_message)
	_current_message = null

	if _messages.is_empty():
		queue_depleted.emit()
