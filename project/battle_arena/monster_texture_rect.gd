class_name MonsterTextureRect
extends TextureRect

var _monster: Monster
var _current_event: MoveEvent


func set_player(player: Monster) -> void:
	_monster = player
	texture = _monster.get_texture()


func handle_event(event: Event) -> void:
	if event is not MoveEvent:
		return

	_handle_move_event(event)


func _handle_move_event(event: MoveEvent) -> void:
	if event.get_monster() != _monster:
		return

	_current_event = event
	_current_event.start(self)
	_play_animation()


func _play_animation() -> void:
	var tween := get_tree().create_tween()
	tween.tween_property(self, "position", position + Vector2.UP * 20, 0.2)
	tween.tween_property(self, "position", position, 0.25)
	tween.play()
	tween.finished.connect(_on_animation_complete)


func _on_animation_complete() -> void:
	if _current_event:
		_current_event.complete(self)
