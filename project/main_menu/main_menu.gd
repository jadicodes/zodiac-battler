extends Control

const MONSTER_SELECT_SCENE = preload("res://monster_select/monster_select.tscn")
const CREDITS_SCENE = preload("res://main_menu/credits.tscn")


func start_game() -> void:
	get_tree().change_scene_to_packed(MONSTER_SELECT_SCENE)


func show_credits() -> void:
	add_child(CREDITS_SCENE.instantiate())
