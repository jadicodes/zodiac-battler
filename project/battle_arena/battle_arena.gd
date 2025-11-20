extends Control

@export var _monster_opponent: Monster
@export var _monster_self: Monster

var _game_active := true


func _ready() -> void:
	_monster_opponent.initialize()
	_monster_self.initialize()
	_monster_opponent.on_faint.connect(_win)
	_monster_self.on_faint.connect(_lose)


func _process_turn(monsters: Array[Monster], self_move_index: int) -> void:
	var turn_order := Monster.order_by_speed(monsters)

	for i in len(turn_order):
		if not _game_active:
			return
		if turn_order[i].get_belongs_to_player():
			turn_order[i].use_move(turn_order[1-i], self_move_index)
		else:
			turn_order[i].use_move(turn_order[1-i], randi_range(0,3))


func _win() -> void:
	_game_active = false
	print("YOU WIN!!!")


func _lose() -> void:
	_game_active = false
	print("YOU LOSE :'(")


func _on_move_button_pressed(move_index: int) -> void:
	_process_turn([_monster_opponent, _monster_self], move_index)
