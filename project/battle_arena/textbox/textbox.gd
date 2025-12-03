class_name Textbox
extends Control

signal message_started
signal message_skipped
signal message_ended

enum State {
	READY,
	READING,
	FINISHED,
}

const CHARS_PER_SECOND := 50.0

var _current_state := State.READY
var _current_message: MessageEvent

@onready var _label: RichTextLabel = %Label
@onready var _tween: Tween


func handle_event(event: Event) -> void:
	if event is MessageEvent:
		_current_message = event

	if _current_state == State.READY:
		_show_text()


func _show_text() -> void:
	_current_message.start()
	_label.text = _current_message.get_message()
	_create_tween()
	_change_state(State.READING)


func skip_text() -> void:
	if _current_state == State.READING:
		message_skipped.emit()
		_change_state(State.FINISHED)


func reset() -> void:
	if _current_state == State.FINISHED:
		_change_state(State.READY)


func get_state() -> State:
	return _current_state


func _create_tween() -> void:
	if _tween:
		_tween.kill()

	_tween = get_tree().create_tween()

	_tween.tween_property(
		_label,
		"visible_ratio",
		1.0,
		len(_label.text) / CHARS_PER_SECOND,
	).from(0.0)
	_tween.finished.connect(_change_state.bind(State.FINISHED))


func _change_state(state: State) -> void:
	_current_state = state

	match _current_state:
		State.READY:
			if _current_message:
				_show_text()
		State.READING:
			message_started.emit()
			_tween.play()
		State.FINISHED:
			if _current_message:
				_current_message.complete.call_deferred()
				_current_message = null
			message_ended.emit()
			_label.visible_ratio = 1.0
			_tween.pause()
