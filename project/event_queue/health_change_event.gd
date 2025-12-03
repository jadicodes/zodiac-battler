class_name HealthChangeEvent
extends Event

var _monster: Monster
var _amount := 0


func _init(monster: Monster, amount: int) -> void:
	_monster = monster
	_amount = amount


func get_monster() -> Monster:
	return _monster


func get_amount() -> int:
	return _amount
