extends TextureButton

@export var _breed: Breed

const FRAME = preload("res://monster_select/frame.png")
const FRAME_HOVER = preload("res://monster_select/frame_hover.png")

signal selected(breed)
signal hovered(breed)

func _ready() -> void:
	texture_normal = FRAME
	texture_hover = FRAME_HOVER
	_set_monster_texture()


func get_breed() -> Breed:
	return _breed


func _set_monster_texture() -> void:
	%MonsterTexture.texture = _breed.get_normal_texture_front()


func _on_pressed() -> void:
	selected.emit(_breed)


func _on_focus_entered() -> void:
	hovered.emit(_breed)


func _on_mouse_entered() -> void:
	hovered.emit(_breed)
