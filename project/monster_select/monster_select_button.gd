extends Button

signal selected(breed)
signal hovered(breed)

@onready var _clip_box: Control = %ClipBox
@onready var _monster_texture: Control = %MonsterTexture

@export var _breed: Breed

func _ready() -> void:
	_set_monster_texture()


func get_breed() -> Breed:
	return _breed


func _set_monster_texture() -> void:
	_monster_texture.texture = _breed.get_normal_texture_front()
	_update_focus()


func _update_focus() -> void:
	var center := _clip_box.size / 2
	_monster_texture.position = center - Vector2(_breed._focus_point)


func _on_pressed() -> void:
	selected.emit(_breed)


func _on_focus_entered() -> void:
	hovered.emit(_breed)


func _on_mouse_entered() -> void:
	hovered.emit(_breed)
