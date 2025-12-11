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


static func is_super_effective(move: Type, monster: Type) -> bool:
	return monster == _type_chart[move]


static func is_not_effective(move: Type, monster: Type) -> bool:
	return move == _type_chart[monster]
