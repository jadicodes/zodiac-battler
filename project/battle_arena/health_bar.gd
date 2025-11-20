extends ProgressBar

var _current_health: int


func _update_health_bar() -> void:
	value = _current_health


func add_health(amount: int) -> void:
	_current_health += amount
	_update_health_bar()


func subtract_health(amount: int) -> void:
	_current_health -= amount
	_update_health_bar()


func on_game_start(max_health: int):
	max_value = max_health
	_current_health = max_health
	_update_health_bar()
