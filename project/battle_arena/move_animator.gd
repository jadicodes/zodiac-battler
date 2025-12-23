class_name MoveAnimator
extends Node

const ANIMATION_LENGTH = 0.7
const ANIMATION_SCALE = 32.0

@onready var _sprite: Sprite2D = %Sprite2D
@onready var _particles: CPUParticles2D = %CPUParticles2D

@onready var _rail_main: Node2D = %RailMain
@onready var _rail_cross: Node2D = %RailCross
@onready var _mount: Node2D = %Mount

var _monster_self: Monster
var _monster_opponent: Monster
var _current_event: MoveEvent

@export var _attack_self_marker: Node2D
@export var _attack_opponent_marker: Node2D


func _process(_delta: float) -> void:
	_mount.global_rotation = 0


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
	_play_animation(event.get_move().get_animation_type())


func _play_animation(animation_type: Move.AnimationType) -> void:
	var start := _attack_self_marker.position
	var end := _attack_opponent_marker.position

	if _current_event.get_monster() == _monster_opponent:
		start = _attack_opponent_marker.position
		end = _attack_self_marker.position

	_rail_main.global_position = start
	_rail_cross.position = Vector2.ZERO
	_rail_cross.rotation = 0
	_mount.position = Vector2.ZERO
	_sprite.show()
	_particles.emitting = true

	_rail_main.look_at(end)

	var animation := _play_straight_animation

	match animation_type:
		Move.AnimationType.ZIGZAG:
			animation = _play_zig_zag_animation

	animation.call(start, end).finished.connect(_on_animation_complete)


func _play_straight_animation(_start: Vector2, end: Vector2) -> Tween:
	var tween := get_tree().create_tween()
	tween.tween_property(_rail_main, "position", end, ANIMATION_LENGTH)
	tween.play()

	return tween


func _play_zig_zag_animation(_start: Vector2, end: Vector2) -> Tween:
	var tween := get_tree().create_tween()
	tween.tween_property(_rail_main, "position", end, ANIMATION_LENGTH)
	tween.play()

	var cross_tween := get_tree().create_tween()
	cross_tween.tween_property(_rail_cross, "position:y", ANIMATION_SCALE, ANIMATION_LENGTH / 3.0)
	cross_tween.tween_property(_rail_cross, "position:y", -ANIMATION_SCALE, ANIMATION_LENGTH / 3.0)
	cross_tween.tween_property(_rail_cross, "position:y", 0, ANIMATION_LENGTH / 3.0)
	cross_tween.play()

	return tween


func _on_animation_complete() -> void:
	_sprite.hide()
	_particles.emitting = false
	if _current_event:
		_current_event.complete(self)
