class_name Monster
extends Resource

@export var _breed: Breed

var _remaining_health_points: int


func _ready() -> void:
	_remaining_health_points = _breed.get_health_points()


func get_monster_name() -> String:
	return _breed.get_monster_name()


func get_type() -> Types.Type:
	return _breed.get_type()


func get_moves() -> Array[Move]:
	return _breed.get_moves()


func get_remaining_health_points() -> int:
	return _remaining_health_points


func get_total_health_points() -> int:
	return _breed.get_health_points()


func get_speed() -> int:
	return _breed.get_speed()
