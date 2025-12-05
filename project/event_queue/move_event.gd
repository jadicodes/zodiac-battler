class_name MoveEvent
extends Event

var _monster: Monster
var _move: Move


func _init(monster: Monster, move: Move) -> void:
	_monster = monster
	_move = move


func get_monster() -> Monster:
	return _monster


func get_move() -> Move:
	return _move
