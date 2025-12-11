class_name GameEndButtons
extends Control

signal rematch_selected
signal new_game_selected

@onready var _rematch_button: Button = %RematchButton
@onready var _new_game_button: Button = %NewGameButton
 

func _ready() -> void:
	_rematch_button.pressed.connect(rematch_selected.emit)
	_new_game_button.pressed.connect(new_game_selected.emit)
