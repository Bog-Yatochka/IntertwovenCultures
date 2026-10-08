extends SceneTree

func _fail(message: String, code: int) -> void:
	printerr(message)
	quit(code)

func _init() -> void:
	var manager := GameManager.new()
	for count in [2, 4, 10, 20]:
		var specs: Array[Dictionary] = []
		for i in range(count):
			specs.append({"name": "", "country": "Ukraine" if i % 2 == 0 else "Poland"})
		if not manager.setup(specs): _fail("SETUP_FAILED %d" % count, 1); return
		if manager.players.size() != count: _fail("COUNT_FAILED %d" % count, 2); return
		var names := {}
		for i in range(count):
			var player := manager.players[i]
			if names.has(player.player_name) or player.position != 0: _fail("PLAYER_INIT_FAILED %d/%d" % [count, i], 3); return
			names[player.player_name] = true
			var target := "Poland" if player.country == "Ukraine" else "Ukraine"
			manager.current_turn = i
			var question := manager.question_for_current("history")
			if question.target != target: _fail("QUESTION_MAPPING_FAILED %d/%d" % [count, i], 4); return
		manager.current_turn = 0
		for expected in range(count * 2):
			if manager.current_turn != expected % count: _fail("TURN_ORDER_FAILED %d/%d" % [count, expected], 5); return
			manager.next_turn()
		manager.players[count - 1].position = GameManager.FINISH_POSITION
		manager.current_turn = count - 1
		var movement := manager.roll_and_move()
		if not movement.winner or movement.player != manager.players[count - 1]: _fail("WINNER_FAILED %d" % count, 6); return
	if manager.setup([{"name": "only", "country": "Ukraine"}]): _fail("MINIMUM_RULE_FAILED", 7); return
	var cap_specs: Array[Dictionary] = []
	for i in range(GameManager.MAX_PLAYERS + 1): cap_specs.append({"name": "P" + str(i), "country": "Ukraine"})
	if manager.setup(cap_specs): _fail("MAXIMUM_RULE_FAILED", 8); return
	print("VARIABLE_PLAYERS_OK counts=2,4,10,20 min=2 max=20")
	quit(0)
