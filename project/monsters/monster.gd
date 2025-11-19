class_name Monster
extends Resource

@export var _breed: Breed

var _remaining_health_points: int


func _ready() -> void:
	_remaining_health_points = _breed.get_health_points()


func use_move(target: Monster, move: Move) -> void:
	print("Using move " + move._move_name)
	var accuracy: int = move.get_accuracy()
	var attack_power: int = move.get_attack_power()
	var random_number = randi_range(0, 100)
	if random_number < accuracy:
		@warning_ignore("integer_division")
		target.take_damage(attack_power/2)


func take_damage(damage_amount: int) -> void:
	_remaining_health_points -= damage_amount
	print(get_monster_name() + " lost " + str(damage_amount) + " hp.")


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
