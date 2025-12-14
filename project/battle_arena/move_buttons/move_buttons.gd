class_name MoveButtons
extends Control

signal move_selected(move_index: int)

@onready var _buttons: Array[Button] = [%Move1, %Move2, %Move3, %Move4]


func _ready() -> void:
	for i in len(_buttons):
		_buttons[i].pressed.connect(move_selected.emit.bind(i))
		_buttons[i].mouse_entered.connect(_buttons[i].grab_focus)
		_buttons[i].mouse_exited.connect(grab_focus)
	
	set_focus_mode(Control.FOCUS_CLICK)
	set_focus_next(_buttons[0].get_path())
	set_focus_neighbor(Side.SIDE_LEFT, _buttons[0].get_path())
	set_focus_neighbor(Side.SIDE_RIGHT, _buttons[1].get_path())
	set_focus_neighbor(Side.SIDE_TOP, _buttons[2].get_path())
	set_focus_neighbor(Side.SIDE_BOTTOM, _buttons[3].get_path())
	grab_focus()


func set_moves(moves: Array[Move]) -> void:
	for i in len(_buttons):
		_buttons[i].text = moves[i].get_move_name()
		_buttons[i].get_child(0).modulate = Types.get_color(moves[i].get_type())


func enable() -> void:
	for button in _buttons:
		button.disabled = false


func disable() -> void:
	for button in _buttons:
		button.disabled = true
