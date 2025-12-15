extends Control

var _monster: Monster


func set_player(player: Monster) -> void:
	_monster = player
	%NameLabel.text = player.get_monster_name()
	%HealthBar.set_max_health(player.get_total_health_points())


func handle_event(event: Event) -> void:
	if not event is HealthChangeEvent:
		return

	_handle_health_change_event(event)


func _handle_health_change_event(event: HealthChangeEvent) -> void:
	if event.get_monster() != _monster:
		return

	event.start(self)
	subtract_health(event.get_amount())
	event.complete.call_deferred(self)


func subtract_health(amount) -> void:
	%HealthBar.subtract_health(amount)
