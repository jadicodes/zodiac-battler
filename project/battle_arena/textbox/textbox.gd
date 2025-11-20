class_name Textbox
extends Control

enum State {
	READY,
	READING,
	FINISHED,
}

const CHARS_PER_SECOND := 30.0

var _current_state := State.READY

@onready var _label: RichTextLabel = %Label
@onready var _tween: Tween = get_tree().create_tween()


func _ready() -> void:
	show_text("EMBERMANE hurt itself in confusion!")


func show_text(text: String) -> void:
	_label.text = text
	_create_tween()
	_change_state(State.READING)


func skip() -> void:
	_change_state(State.FINISHED)


func available() -> bool:
	return _current_state in [State.READY, State.FINISHED]


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
			_label.visible_ratio = 0.0
		State.READING:
			_tween.play()
		State.FINISHED:
			_label.visible_ratio = 1.0
			_tween.pause()
