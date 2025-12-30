extends Control

const BATTLE_ARENA_SCENE := "res://battle_arena/battle_arena.tscn"

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
			Transition.to(BATTLE_ARENA_SCENE)
		_monster_select_state = state


func _ready() -> void:
	%HoveredSelfPanel.visible = false
	%SelfTexture.visible = false
	%HoveredOpponentPanel.visible = false
	%OpponentTexture.visible = false
	_set_state(State.CHOOSE_SELF)


func _set_state(state: int) -> void:
	_monster_select_state = state


func _select_monster(breed: Breed) -> void:
	_set_portrait(breed)
	if _monster_select_state == State.CHOOSE_SELF:
		_self_monster = breed
		_set_state(State.CHOOSE_OPPONENT)
	elif _monster_select_state == State.CHOOSE_OPPONENT:
		_opponent_monster = breed
		_set_state(State.PLAY)


func _on_monster_select_button_hovered(breed: Breed) -> void:
	_set_portrait(breed)


func _set_portrait(breed) -> void:
	if _monster_select_state == State.CHOOSE_SELF:
		%HoveredSelfLabel.text = breed.get_monster_name()
		%HoveredSelfPanel.visible = true
		%SelfTexture.texture = breed.get_normal_texture_front()
		%SelfTexture.visible = true
	if _monster_select_state == State.CHOOSE_OPPONENT:
		%HoveredOpponentLabel.text = breed.get_monster_name()
		%HoveredOpponentPanel.visible = true
		%OpponentTexture.texture = breed.get_normal_texture_front()
		%OpponentTexture.visible = true


func _on_random_button_pressed() -> void:
	var all_possible_monsters = []
	for child in get_tree().get_nodes_in_group("select_buttons"):
		all_possible_monsters.append(child.get_breed())
	_select_monster(all_possible_monsters.pick_random())
