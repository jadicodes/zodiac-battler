class_name MoveAnimator
extends Node

@onready var _sprite: Sprite2D = %Sprite2D
@onready var _particles: CPUParticles2D = %CPUParticles2D

var _monster_self: Monster
var _monster_opponent: Monster
var _current_event: MoveEvent

@export var _attack_self_marker: Node2D
@export var _attack_opponent_marker: Node2D


func _process(_delta: float) -> void:
	_particles.position = _sprite.position

func set_monsters(monster_self: Monster, monster_opponent: Monster) -> void:
	_monster_self = monster_self
	_monster_opponent = monster_opponent


func handle_event(event: Event) -> void:
	if event is not MoveEvent:
		return

	_handle_move_event(event)


func _handle_move_event(event: MoveEvent) -> void:
	if event.get_monster() not in [_monster_self, _monster_opponent]:
		return

	_current_event = event
	_sprite.texture = event.get_move().get_move_texture()
	_particles.texture = event.get_move().get_move_texture()
	_current_event.start(self)
	_play_animation()


func _play_animation() -> void:
	var start := _attack_self_marker.position
	var end := _attack_opponent_marker.position
	
	if _current_event.get_monster() == _monster_opponent:
		start = _attack_opponent_marker.position
		end = _attack_self_marker.position


	_sprite.position = start
	_particles.position = start
	_sprite.show()
	_particles.emitting = true
	var tween := get_tree().create_tween()
	tween.tween_property(
		_sprite,
		"position",
		end,
		0.5
	)
	tween.play()
	tween.finished.connect(_on_animation_complete)


func _on_animation_complete() -> void:
	_sprite.hide()
	_particles.emitting = false
	if _current_event:
		_current_event.complete(self)
