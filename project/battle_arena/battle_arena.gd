extends Control

@export var _monster_opponent: Monster
@export var _monster_self: Monster


func _ready() -> void:
	var monsters := Monster.order_by_speed([_monster_opponent, _monster_self])
	monsters[0].use_move(monsters[1], monsters[0].get_moves()[0])
	monsters[1].use_move(monsters[0], monsters[1].get_moves()[0])
