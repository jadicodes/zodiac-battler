extends Control


func set_player(player: Monster) -> void:
	%NameLabel.text = player.get_monster_name()
	%HealthBar.set_max_health(player.get_total_health_points())


func subtract_health(amount) -> void:
	%HealthBar.subtract_health(amount)
