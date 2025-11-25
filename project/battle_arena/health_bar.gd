extends ProgressBar

var _current_health: int
var _tween_duration := 0.25
var _tween: Tween


func _update_health_bar() -> void:
	if _tween and _tween.is_running():
		_tween.kill()

	_tween = create_tween()
	_tween.tween_property(
		self,
		"value",
		_current_health,
		_tween_duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func add_health(amount: int) -> void:
	_current_health += amount
	_update_health_bar()


func subtract_health(amount: int) -> void:
	_current_health -= amount
	_update_health_bar()


func set_max_health(max_health: int):
	max_value = max_health
	_current_health = max_health
	_update_health_bar()
