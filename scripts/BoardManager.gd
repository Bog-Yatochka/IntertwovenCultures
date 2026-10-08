class_name BoardManager
extends RefCounted

const CATEGORIES := ["GEOGRAPHY", "CULTURE", "FOOD", "LANGUAGE", "INTERACTION"]
const CATEGORY_COLORS := {
	"GEOGRAPHY": Color("#e85d75"),
	"CULTURE": Color("#4b8bd8"),
	"FOOD": Color("#4caf78"),
	"LANGUAGE": Color("#e6b84c"),
	"INTERACTION": Color("#a77bd8")
}
const CATEGORY_ICONS := {
	"GEOGRAPHY": "◈", "CULTURE": "★", "FOOD": "●", "LANGUAGE": "A", "INTERACTION": "♥"
}

var spaces: Array[Dictionary] = []

func _init() -> void:
	for i in range(51):
		var category: String = "START" if i == 0 else ("FINISH" if i == 50 else CATEGORIES[(i - 1) % CATEGORIES.size()])
		spaces.append({"index": i, "category": category})

func category_color(category: String) -> Color:
	return CATEGORY_COLORS.get(category, Color("#334155"))

func category_icon(category: String) -> String:
	return CATEGORY_ICONS.get(category, "")

func grid_position(index: int, columns: int = 10) -> Vector2i:
	var row := index / columns
	var col := index % columns
	if row % 2 == 1:
		col = columns - 1 - col
	return Vector2i(col, row)
