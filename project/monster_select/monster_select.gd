extends Control

var _self_monster: Breed
var _opponent_monster: Breed


enum State {
	CHOOSE_SELF,
	CHOOSE_OPPONENT,
	PLAY
}


var _monster_select_state:
	set(state):
		if state == State.CHOOSE_SELF:
			%SelectYourMonsterLabel.text = "SELECT YOUR FIGHTER!"
		if state == State.CHOOSE_OPPONENT:
			%SelectYourMonsterLabel.text = "SELECT YOUR OPPONENT!"
		if state == State.PLAY:
			MonsterSelections.self_breed = _self_monster
			MonsterSelections.opponent_breed = _opponent_monster
			get_tree().change_scene_to_file("res://battle_arena/battle_arena.tscn")
		_monster_select_state = state


func _ready() -> void:
	_set_state(State.CHOOSE_SELF)


func _set_state(state: int) -> void:
	_monster_select_state = state


func _select_monster(breed: Breed) -> void:
	if _monster_select_state == State.CHOOSE_SELF:
		_self_monster = breed
		_set_state(State.CHOOSE_OPPONENT)
	elif _monster_select_state == State.CHOOSE_OPPONENT:
		_opponent_monster = breed
		_set_state(State.PLAY)


func _on_monster_select_button_hovered(breed: Breed) -> void:
	$HoveredMonsterPanel/HoveredMonsterLabel.text = breed.get_monster_name()
