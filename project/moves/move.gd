class_name Move
extends Resource

@export var _move_name: String
@export var _type: Types.Type
@export var _attack_power: int
@export var _attempts: int
@export var _accuracy: int


func get_move_name() -> String:
	return _move_name


func get_type() -> Types.Type:
	return _type


func get_attack_power() -> int:
	return _attack_power


func get_attempts() -> int:
	return _attempts


func get_accuracy() -> int:
	return _accuracy
