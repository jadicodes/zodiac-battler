extends Control

const ANIMATION_LENGTH: float = 0.5
const PAUSE_LENGTH: float = 0.25

@onready var _panel: Panel = %Panel

var _y_threshold := 0.0

var _to_scene: PackedScene


func _ready() -> void:
	_panel.visible = false


func _process(_delta: float) -> void:
	_update_y_threshold()


func to(scene: PackedScene) -> void:
	_to_scene = scene
	_start()


func _start() -> void:
	_y_threshold = 0.0
	_update_y_threshold()
	_panel.visible = true
	var tween := get_tree().create_tween()
	tween.tween_property(self, "_y_threshold", 1.0, ANIMATION_LENGTH)
	tween.tween_property(self, "_y_threshold", 1.0, PAUSE_LENGTH)
	tween.play()
	tween.finished.connect(_end)


func _end() -> void:
	get_tree().change_scene_to_packed(_to_scene)
	var tween := get_tree().create_tween()
	tween.tween_property(self, "_y_threshold", 0, ANIMATION_LENGTH)
	tween.play()
	tween.finished.connect(_complete)


func _complete() -> void:
	_to_scene = null
	_panel.visible = false


func _update_y_threshold() -> void:
	if _to_scene:
		_panel.material.set_shader_parameter("y_threshold", _y_threshold)
