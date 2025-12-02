class_name EventQueue
extends Node

signal event_started(event: Event)
signal event_ended(event: Event)
signal queue_started()
signal queue_depleted


var _events: Array[Event] = []
var _current_event: Event


func add_event(event: Event) -> void:
	_events.append(event)
	if _current_event == null:
		queue_started.emit()
		advance()


func advance() -> void:
	if _current_event:
		return

	if _events.is_empty():
		return

	_current_event = _events.pop_front()
	event_started.emit(_current_event)
	_current_event.completed.connect(_on_event_completed.bind(_current_event))


func _on_event_completed(event: Event) -> void:
	assert(event == _current_event, "EVENT ENDED THAT WASN'T CURRENT EVENT")

	event_ended.emit(_current_event)
	_current_event = null
	event.completed.disconnect(_on_event_completed)

	if _events.is_empty():
		queue_depleted.emit()
	else:
		advance()
