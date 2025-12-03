class_name Breed
extends Resource

@export var _monster_name: String
@export var _type: Types.Type
@export var _moves: Array[Move]
@export var _health_points: int
@export var _speed: int

@export var _normal_texture_front: Texture2D
@export var _normal_texture_back: Texture2D
@export var _attack_texture_front: Texture2D
@export var _attack_texture_back: Texture2D


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


func get_normal_texture_front() -> Texture2D:
	return _normal_texture_front


func get_normal_texture_back() -> Texture2D:
	return _normal_texture_back


func get_attack_texture_front() -> Texture2D:
	return _attack_texture_front


func get_attack_texture_back() -> Texture2D:
	return _attack_texture_back
