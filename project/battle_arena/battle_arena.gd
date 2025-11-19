extends Control

@export var _monster_opponent: Monster
@export var _monster_self: Monster


func _ready() -> void:
	_monster_self.use_move(_monster_opponent, _monster_self.get_moves()[0])
	_monster_opponent.use_move(_monster_self, _monster_opponent.get_moves()[0])
