extends TextureButton

@export var _breed: Breed

signal selected(breed)


func _ready() -> void:
	_set_monster_texture()


func get_breed() -> Breed:
	return _breed


func _set_monster_texture() -> void:
	texture_normal = _breed.get_normal_texture_front()


func _on_pressed() -> void:
	print("PRESSED")
	selected.emit(_breed)
