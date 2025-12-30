extends Control

const MONSTER_SELECT_SCENE := "res://monster_select/monster_select.tscn"
const CREDITS_SCENE := "res://main_menu/credits.tscn"


func start_game() -> void:
	Transition.to(MONSTER_SELECT_SCENE)


func show_credits() -> void:
	add_child(preload(CREDITS_SCENE).instantiate())
