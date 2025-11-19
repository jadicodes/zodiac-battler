extends Control

@export var _monster_opponent: Monster
@export var _monster_self: Monster

var _game_active := true

func _ready() -> void:
	_monster_opponent.initialize()
	_monster_self.initialize()
	_monster_opponent.on_faint.connect(_win)
	_monster_self.on_faint.connect(_lose)

	while _game_active:
		_process_turn([_monster_opponent, _monster_self])


func _process_turn(monsters: Array[Monster]) -> void:
	var turn_order := Monster.order_by_speed(monsters)

	if not _game_active:
		return
	turn_order[0].use_move(turn_order[1], turn_order[0].get_moves()[0])

	if not _game_active:
		return
	turn_order[1].use_move(turn_order[0], turn_order[1].get_moves()[0])


func _win() -> void:
	_game_active = false
	print("YOU WIN!!!")


func _lose() -> void:
	_game_active = false
	print("YOU LOSE :'(")
