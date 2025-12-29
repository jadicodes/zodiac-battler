class_name Types

enum Type {
	EARTH,
	WIND,
	FIRE,
	WATER
}

static var _type_chart: Dictionary[Type, Type] = {
	Type.EARTH: Type.WIND,
	Type.WIND: Type.WATER,
	Type.WATER: Type.FIRE,
	Type.FIRE: Type.EARTH
}

static var _type_color: Dictionary[Type, Color] = {
	Type.EARTH: Color.hex(0x3ec54bff),
	Type.WIND: Color.hex(0x8c7f90ff),
	Type.WATER: Color.hex(0x4656a5ff),
	Type.FIRE: Color.hex(0xb22741ff)
}

static var _type_secondary_color: Dictionary[Type, Color] = {
	Type.EARTH: Color.hex(0xb4e656ff),
	Type.WIND: Color.hex(0xbcb0b3ff),
	Type.WATER: Color.hex(0x4995f3ff),
	Type.FIRE: Color.hex(0xf5464cff)
}


static func is_super_effective(move: Type, monster: Type) -> bool:
	return monster == _type_chart[move]


static func is_not_effective(move: Type, monster: Type) -> bool:
	return move == _type_chart[monster]


static func get_color(type: Type):
	return _type_color[type]


static func get_secondary_color(type: Type):
	return _type_secondary_color[type]
