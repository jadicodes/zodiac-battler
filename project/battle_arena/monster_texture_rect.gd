class_name MonsterTextureRect
extends TextureRect

var _monster: Monster
var _current_event: Event


func set_player(player: Monster) -> void:
	_monster = player
	texture = _monster.get_texture()


func handle_event(event: Event) -> void:
	if event is MoveEvent:
		_handle_move_event(event)
	if event is HealthChangeEvent:
		_handle_health_change_event(event)


func _handle_move_event(event: MoveEvent) -> void:
	if event.get_monster() != _monster:
		return

	_claim_event(event)
	_play_attack_animation().finished.connect(_on_animation_complete)


func _handle_health_change_event(event: HealthChangeEvent) -> void:
	if event.get_monster() != _monster:
		return

	_claim_event(event)
	_play_damage_animation().finished.connect(_on_animation_complete)


func _claim_event(event: Event) -> void:
	_current_event = event
	_current_event.start(self)


func _play_attack_animation() -> Tween:
	var tween := get_tree().create_tween()
	tween.tween_property(self, "position", position + Vector2.UP * 20, 0.2)
	tween.tween_property(self, "position", position, 0.25)
	tween.play()

	return tween


func _play_damage_animation() -> Tween:
	var tween := get_tree().create_tween()
	tween.tween_property(self, "rotation", rotation + 0.1, 0.1)
	tween.tween_property(self, "rotation", rotation - 0.1, 0.2)
	tween.tween_property(self, "rotation", rotation + 0.1, 0.2)
	tween.tween_property(self, "rotation", rotation, 0.1)
	tween.play()

	return tween


func _on_animation_complete() -> void:
	if _current_event:
		_current_event.complete(self)
