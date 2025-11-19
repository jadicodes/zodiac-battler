class_name Breed
extends Resource

@export var _monster_name: String
@export var _type: Types.Type
@export var _moves: Array[Move]
@export var _health_points: int
@export var _speed: int


func get_monster_name() -> String:
	return _monster_name

func get_type() -> Types.Type:
	return _type

func get_moves() -> Array[Move]:
	return _moves

func get_health_points() -> int:
	return _health_points

func get_speed() -> int:
	return _speed
