class_name GameManager
extends RefCounted

const MIN_PLAYERS := 2
const MAX_PLAYERS := 20
const FINISH_POSITION := 50

var board: BoardManager
var question_manager: QuestionManager
var players: Array[Player] = []
var current_turn: int = 0
var last_roll: int = 0

func _init() -> void:
	board = BoardManager.new()
	question_manager = QuestionManager.new()
	randomize()

func setup(player_specs: Array[Dictionary]) -> bool:
	if player_specs.size() < MIN_PLAYERS or player_specs.size() > MAX_PLAYERS:
		return false
	players.clear()
	var blue_colors := [Color("#2563eb"), Color("#3b82f6"), Color("#60a5fa"), Color("#1d4ed8"), Color("#38bdf8")]
	var red_colors := [Color("#dc334d"), Color("#ef4444"), Color("#f87171"), Color("#be123c"), Color("#fb7185")]
	var used_names: Dictionary = {}
	for i in range(player_specs.size()):
		var spec: Dictionary = player_specs[i]
		var country := str(spec.get("country", "Ukraine"))
		if country != "Ukraine" and country != "Poland":
			return false
		var base_name := str(spec.get("name", "")).strip_edges()
		if base_name.is_empty():
			base_name = country + " " + str(i + 1)
		var player_name := base_name
		var suffix := 2
		while used_names.has(player_name):
			player_name = base_name + " " + str(suffix)
			suffix += 1
		used_names[player_name] = true
		var colors: Array = blue_colors if country == "Ukraine" else red_colors
		var emoji := "🇺🇦" if country == "Ukraine" else "🇵🇱"
		players.append(Player.new(player_name, country, emoji, colors[i % colors.size()]))
	current_turn = 0
	last_roll = 0
	return true

func current_player() -> Player:
	if players.is_empty():
		return null
	return players[current_turn]

func roll_and_move() -> Dictionary:
	if players.is_empty():
		return {}
	last_roll = randi_range(1, 6)
	var player := current_player()
	player.position = mini(FINISH_POSITION, player.position + last_roll)
	var space: Dictionary = board.spaces[player.position]
	return {"roll": last_roll, "position": player.position, "category": space.category, "winner": player.position >= FINISH_POSITION, "player": player}

func question_for_current(category: String) -> Dictionary:
	var player := current_player()
	if player == null:
		return {}
	var target := "Poland" if player.country == "Ukraine" else "Ukraine"
	return question_manager.get_question(category, target)

func next_turn() -> void:
	if players.is_empty():
		current_turn = 0
		return
	current_turn = (current_turn + 1) % players.size()

func current_player_index() -> int:
	return current_turn
