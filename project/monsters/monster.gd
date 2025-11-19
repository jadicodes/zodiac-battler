class_name Monster
extends Resource

signal on_use_move(target: Monster, move: Move)
signal on_take_damage(damage_amount: int)
signal on_faint

@export var _breed: Breed

var _remaining_health_points: int


func initialize() -> void:
	_remaining_health_points = _breed.get_health_points()


func use_move(target: Monster, move: Move) -> void:
	on_use_move.emit(target, move)
	print("Using move " + move._move_name)
	var accuracy: int = move.get_accuracy()
	var attack_power: int = move.get_attack_power()
	var random_number = randi_range(0, 100)

	if random_number < accuracy:
		@warning_ignore("integer_division")
		target.take_damage(attack_power / 10)
	else:
		print("Missed...")


func take_damage(damage_amount: int) -> void:
	print(_remaining_health_points, " - ", damage_amount)
	_remaining_health_points -= damage_amount
	on_take_damage.emit(damage_amount)
	print(get_monster_name() + " lost " + str(damage_amount) + " hp.")

	if _remaining_health_points <= 0:
		on_faint.emit()


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


static func order_by_speed(monsters: Array[Monster]) -> Array[Monster]:
	var sorted_monsters := monsters.duplicate()
	sorted_monsters.sort_custom(compare_speed)

	return sorted_monsters


static func compare_speed(a: Monster, b: Monster) -> bool:
	return a.get_speed() > b.get_speed()
