extends Control

const BG := Color("#0f172a")
const CARD := Color("#1e293b")
const TEXT := Color("#f8fafc")
const MUTED := Color("#94a3b8")
const ACCENT := Color("#38bdf8")
const SUCCESS := Color("#4ade80")
const ERROR := Color("#fb7185")

var game: GameManager
var screen: Control
var board_grid: GridContainer
var info_panel: VBoxContainer
var turn_label: Label
var dice_label: Label
var roll_button: Button
var question_panel: PanelContainer
var question_content: VBoxContainer
var selected_answer: String = ""
var current_question: Dictionary
var setup_rows: Array[Dictionary] = []
var setup_list: VBoxContainer
var setup_count_label: Label
var setup_error_label: Label
var add_player_button: Button
var board_cells: Array[PanelContainer] = []
var player_status_labels: Array[Label] = []
var cell_labels: Array[Label] = []

# Responsive sizing
var base_font_size: int = 16
var scale_factor: float = 1.0

func _ready() -> void:
	Localization.load_settings()
	game = GameManager.new()
	get_viewport().size_changed.connect(_on_viewport_size_changed)
	_calculate_scale()
	_show_menu()

func _on_viewport_size_changed() -> void:
	_calculate_scale()

func _calculate_scale() -> void:
	var viewport_size := get_viewport_rect().size
	# Base size is 1280x720
	var scale_x := viewport_size.x / 1280.0
	var scale_y := viewport_size.y / 720.0
	scale_factor = min(scale_x, scale_y)
	scale_factor = clamp(scale_factor, 0.5, 2.0)

func _scaled(value: int) -> int:
	return int(value * scale_factor)

func _clear() -> void:
	for child in get_children(): child.queue_free()
	screen = Control.new()
	screen.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(screen)

func _label(text: String, size: int = 16, color: Color = TEXT) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", _scaled(size))
	label.add_theme_color_override("font_color", color)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return label

func _button(text: String, callback: Callable) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(_scaled(180), _scaled(48))
	button.add_theme_font_size_override("font_size", _scaled(17))
	button.pressed.connect(callback)
	return button

func _panel_style(color: Color, radius: int = 16) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	var scaled_radius := _scaled(radius)
	style.corner_radius_top_left = scaled_radius
	style.corner_radius_top_right = scaled_radius
	style.corner_radius_bottom_left = scaled_radius
	style.corner_radius_bottom_right = scaled_radius
	style.border_width_left = 1
	style.border_width_top = 1
	style.border_width_right = 1
	style.border_width_bottom = 1
	style.border_color = Color("#334155")
	var margin := _scaled(18)
	style.content_margin_left = margin
	style.content_margin_right = margin
	style.content_margin_top = _scaled(16)
	style.content_margin_bottom = _scaled(16)
	return style

func _make_root() -> VBoxContainer:
	var root := VBoxContainer.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.add_theme_constant_override("separation", _scaled(16))
	var margin := _scaled(32)
	root.add_theme_constant_override("margin_left", margin)
	root.add_theme_constant_override("margin_right", margin)
	root.add_theme_constant_override("margin_top", _scaled(26))
	root.add_theme_constant_override("margin_bottom", _scaled(26))
	return root

func _show_menu() -> void:
	_clear()
	var root := _make_root()
	root.alignment = BoxContainer.ALIGNMENT_CENTER
	screen.add_child(root)
	var title := _label(Localization.t("menu_title"), 48, Color("#facc15"))
	root.add_child(title)
	root.add_child(_label(Localization.t("menu_subtitle"), 22, ACCENT))
	root.add_child(_label(Localization.t("menu_description"), 18, MUTED))
	var spacer := Control.new(); spacer.custom_minimum_size.y = _scaled(18); root.add_child(spacer)
	root.add_child(_button(Localization.t("menu_play"), _show_setup))
	root.add_child(_button(Localization.t("menu_settings"), _show_settings))
	root.add_child(_button(Localization.t("menu_quit"), func() -> void: get_tree().quit()))

func _show_settings() -> void:
	_clear()
	var root := _make_root()
	root.alignment = BoxContainer.ALIGNMENT_CENTER
	screen.add_child(root)

	root.add_child(_label(Localization.t("settings_title"), 34, Color("#facc15")))

	var spacer := Control.new()
	spacer.custom_minimum_size.y = _scaled(20)
	root.add_child(spacer)

	# Language setting
	var lang_container := VBoxContainer.new()
	lang_container.add_theme_constant_override("separation", _scaled(8))
	root.add_child(lang_container)

	lang_container.add_child(_label(Localization.t("settings_language"), 18, ACCENT))

	var lang_buttons := HBoxContainer.new()
	lang_buttons.alignment = BoxContainer.ALIGNMENT_CENTER
	lang_buttons.add_theme_constant_override("separation", _scaled(10))
	lang_container.add_child(lang_buttons)

	var lang_en := _button("English", func() -> void: _change_language(Localization.Language.ENGLISH))
	var lang_uk := _button("Українська", func() -> void: _change_language(Localization.Language.UKRAINIAN))
	var lang_pl := _button("Polski", func() -> void: _change_language(Localization.Language.POLISH))

	lang_buttons.add_child(lang_en)
	lang_buttons.add_child(lang_uk)
	lang_buttons.add_child(lang_pl)

	# Resolution setting
	var sep1 := Control.new()
	sep1.custom_minimum_size.y = _scaled(20)
	root.add_child(sep1)

	var res_container := VBoxContainer.new()
	res_container.add_theme_constant_override("separation", _scaled(8))
	root.add_child(res_container)

	res_container.add_child(_label(Localization.t("settings_resolution"), 18, ACCENT))

	var res_option := OptionButton.new()
	res_option.custom_minimum_size = Vector2(_scaled(300), _scaled(48))
	res_option.add_theme_font_size_override("font_size", _scaled(16))

	for resolution in Settings.AVAILABLE_RESOLUTIONS:
		res_option.add_item("%d × %d" % [resolution.x, resolution.y])

	res_option.selected = Settings.get_resolution_index()

	var res_center := HBoxContainer.new()
	res_center.alignment = BoxContainer.ALIGNMENT_CENTER
	res_center.add_child(res_option)
	res_container.add_child(res_center)

	# Fullscreen setting
	var sep2 := Control.new()
	sep2.custom_minimum_size.y = _scaled(20)
	root.add_child(sep2)

	var fullscreen_container := HBoxContainer.new()
	fullscreen_container.alignment = BoxContainer.ALIGNMENT_CENTER
	fullscreen_container.add_theme_constant_override("separation", _scaled(15))
	root.add_child(fullscreen_container)

	var fullscreen_label := Label.new()
	fullscreen_label.text = Localization.t("settings_fullscreen")
	fullscreen_label.add_theme_font_size_override("font_size", _scaled(18))
	fullscreen_label.add_theme_color_override("font_color", ACCENT)
	fullscreen_label.autowrap_mode = TextServer.AUTOWRAP_OFF
	fullscreen_container.add_child(fullscreen_label)

	var fullscreen_check := CheckBox.new()
	fullscreen_check.button_pressed = Settings.is_fullscreen
	fullscreen_container.add_child(fullscreen_check)

	# Apply and Back buttons
	var sep3 := Control.new()
	sep3.custom_minimum_size.y = _scaled(30)
	root.add_child(sep3)

	var buttons := HBoxContainer.new()
	buttons.alignment = BoxContainer.ALIGNMENT_CENTER
	buttons.add_theme_constant_override("separation", _scaled(14))
	root.add_child(buttons)

	buttons.add_child(_button(Localization.t("setup_back"), _show_menu))
	buttons.add_child(_button(Localization.t("settings_apply"), func() -> void:
		var selected_res: Vector2i = Settings.AVAILABLE_RESOLUTIONS[res_option.selected]
		Settings.set_resolution(selected_res)
		Settings.set_fullscreen(fullscreen_check.button_pressed)
		await get_tree().create_timer(0.1).timeout
		_calculate_scale()
		_show_menu()
	))

func _change_language(lang: Localization.Language) -> void:
	Localization.set_language(lang)
	_show_settings()

func _show_setup() -> void:
	_clear()
	setup_rows.clear()
	var root := _make_root(); screen.add_child(root)
	root.add_child(_label(Localization.t("setup_title"), 34, Color("#facc15")))
	root.add_child(_label(Localization.t("setup_description"), 17, MUTED))
	setup_count_label = _label("", 16, ACCENT); root.add_child(setup_count_label)
	var scroll := ScrollContainer.new(); scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL; root.add_child(scroll)
	setup_list = VBoxContainer.new(); setup_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL; setup_list.add_theme_constant_override("separation", _scaled(8)); scroll.add_child(setup_list)
	_add_setup_row("Max", "Ukraine")
	_add_setup_row("Kuba", "Poland")
	setup_error_label = _label("", 15, ERROR); root.add_child(setup_error_label)
	var buttons := HBoxContainer.new(); buttons.alignment = BoxContainer.ALIGNMENT_CENTER; buttons.add_theme_constant_override("separation", _scaled(14)); root.add_child(buttons)
	add_player_button = _button(Localization.t("setup_add_player"), _add_setup_row); buttons.add_child(add_player_button)
	buttons.add_child(_button(Localization.t("setup_back"), _show_menu)); buttons.add_child(_button(Localization.t("setup_start"), _start_game))
	_update_setup_controls()

func _add_setup_row(default_name: String = "", default_country: String = "Ukraine") -> void:
	if setup_rows.size() >= GameManager.MAX_PLAYERS:
		return
	var row := HBoxContainer.new(); row.custom_minimum_size.y = _scaled(42)
	var number := _label(str(setup_rows.size() + 1), 16, MUTED); number.custom_minimum_size.x = _scaled(30); row.add_child(number)
	var name_input := LineEdit.new()
	name_input.placeholder_text = Localization.t("setup_placeholder", [setup_rows.size() + 1])
	name_input.text = default_name
	name_input.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_input.add_theme_font_size_override("font_size", _scaled(15))
	row.add_child(name_input)

	var country := OptionButton.new()
	country.add_item("🇺🇦 " + Localization.t("country_ukraine"))
	country.add_item("🇵🇱 " + Localization.t("country_poland"))
	country.selected = 0 if default_country == "Ukraine" else 1
	country.custom_minimum_size.x = _scaled(150)
	country.add_theme_font_size_override("font_size", _scaled(14))
	row.add_child(country)

	var remove := Button.new()
	remove.text = Localization.t("setup_remove")
	remove.add_theme_font_size_override("font_size", _scaled(14))
	remove.pressed.connect(func() -> void: _remove_setup_row(row))
	row.add_child(remove)

	setup_list.add_child(row)
	setup_rows.append({"row": row, "name": name_input, "country": country, "number": number})
	_update_setup_controls()

func _remove_setup_row(row: HBoxContainer) -> void:
	if setup_rows.size() <= GameManager.MIN_PLAYERS:
		setup_error_label.text = Localization.t("setup_error_min")
		return
	for i in range(setup_rows.size()):
		if setup_rows[i].row == row:
			setup_rows.remove_at(i)
			break
	row.queue_free()
	_reindex_setup_rows()
	_update_setup_controls()

func _reindex_setup_rows() -> void:
	for i in range(setup_rows.size()):
		setup_rows[i].number.text = str(i + 1)
		setup_rows[i].name.placeholder_text = Localization.t("setup_placeholder", [i + 1])

func _update_setup_controls() -> void:
	if not is_instance_valid(setup_count_label): return
	setup_count_label.text = Localization.t("setup_players", [setup_rows.size(), GameManager.MAX_PLAYERS])
	if is_instance_valid(add_player_button):
		add_player_button.disabled = setup_rows.size() >= GameManager.MAX_PLAYERS

func _start_game() -> void:
	var specs: Array[Dictionary] = []
	for row in setup_rows:
		var country := "Ukraine" if row.country.selected == 0 else "Poland"
		specs.append({"name": row.name.text, "country": country})
	if not game.setup(specs):
		setup_error_label.text = Localization.t("setup_error_range")
		return
	_show_game()

func _show_game() -> void:
	_clear()
	var root := _make_root(); screen.add_child(root)
	var header := HBoxContainer.new(); root.add_child(header)
	var heading := _label(Localization.t("game_title"), 27, Color("#facc15"))
	heading.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	header.add_child(heading)
	var hint := _label(Localization.t("game_subtitle"), 16, MUTED)
	hint.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	header.add_child(hint)

	var body := HBoxContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", _scaled(18))
	root.add_child(body)

	var board_panel := PanelContainer.new()
	board_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	board_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	board_panel.add_theme_stylebox_override("panel", _panel_style(Color("#172554")))
	var board_box := VBoxContainer.new()
	board_panel.add_child(board_box)
	body.add_child(board_panel)

	board_box.add_child(_label(Localization.t("game_board_title"), 18, ACCENT))
	var board_scroll := ScrollContainer.new()
	board_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	board_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	board_box.add_child(board_scroll)

	board_grid = GridContainer.new()
	board_grid.columns = 10
	board_grid.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	board_grid.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	board_grid.add_theme_constant_override("h_separation", _scaled(6))
	board_grid.add_theme_constant_override("v_separation", _scaled(6))
	board_scroll.add_child(board_grid)
	_create_board_cells()

	var side_panel := PanelContainer.new()
	side_panel.custom_minimum_size.x = _scaled(285)
	side_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	side_panel.add_theme_stylebox_override("panel", _panel_style(CARD))
	body.add_child(side_panel)

	var info_scroll := ScrollContainer.new()
	info_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	side_panel.add_child(info_scroll)

	info_panel = VBoxContainer.new()
	info_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info_panel.add_theme_constant_override("separation", _scaled(7))
	info_scroll.add_child(info_panel)

	turn_label = _label("", 22, Color("#facc15"))
	info_panel.add_child(turn_label)
	info_panel.add_child(_label(Localization.t("game_positions"), 14, MUTED))

	player_status_labels.clear()
	for i in range(game.players.size()):
		var p_label := _label("", 17, TEXT)
		p_label.name = "P" + str(i)
		info_panel.add_child(p_label)
		player_status_labels.append(p_label)

	var sep := HSeparator.new()
	info_panel.add_child(sep)

	dice_label = _label("🎲  —", 38, TEXT)
	info_panel.add_child(dice_label)

	roll_button = _button(Localization.t("game_roll"), _roll_dice)
	info_panel.add_child(roll_button)

	info_panel.add_child(_label(Localization.t("game_hint"), 14, MUTED))
	_update_game_ui()

func _create_board_cells() -> void:
	board_cells.clear(); cell_labels.clear()
	for i in range(51):
		var data: Dictionary = game.board.spaces[i]
		var cell := PanelContainer.new()
		cell.custom_minimum_size = Vector2(_scaled(82), _scaled(62))
		cell.add_theme_stylebox_override("panel", _panel_style(game.board.category_color(data.category), 10))
		board_grid.add_child(cell)

		var label_text := str(i) + "\n"
		if i == 0:
			label_text += Localization.t("game_start")
		elif i == 50:
			label_text += Localization.t("game_finish")
		else:
			label_text += game.board.category_icon(data.category)

		var label := _label(label_text, 14, Color.WHITE)
		label.custom_minimum_size = Vector2(_scaled(82), _scaled(62))
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		label.size_flags_vertical = Control.SIZE_EXPAND_FILL
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.clip_text = true
		cell.add_child(label)
		board_cells.append(cell)
		cell_labels.append(label)

func _update_game_ui() -> void:
	if not is_instance_valid(turn_label): return
	var current := game.current_player()
	if current == null: return
	turn_label.text = Localization.t("game_turn", [game.current_turn + 1, current.emoji, current.player_name])
	for i in range(game.players.size()):
		var label: Label = player_status_labels[i] if i < player_status_labels.size() else null
		if label:
			var prefix := "▶ " if i == game.current_turn else ""
			var pos_text := Localization.t("game_position", [game.players[i].position])
			label.text = prefix + game.players[i].emoji + "  " + game.players[i].player_name + "\n" + pos_text
			label.add_theme_color_override("font_color", Color("#facc15") if i == game.current_turn else TEXT)
	dice_label.text = "🎲  " + (str(game.last_roll) if game.last_roll > 0 else "—")
	roll_button.disabled = false
	_refresh_tokens()

func _refresh_tokens() -> void:
	for i in range(board_cells.size()):
		var base := str(i) + "\n"
		if i == 0:
			base += Localization.t("game_start")
		elif i == 50:
			base += Localization.t("game_finish")
		else:
			base += game.board.category_icon(game.board.spaces[i].category)

		var here: Array[Player] = []
		for p in game.players:
			if p.position == i: here.append(p)
		var token_text := ""
		if not here.is_empty():
			if here.size() == 1:
				token_text = "\n" + here[0].player_name
			elif here.size() == 2:
				token_text = "\n" + here[0].player_name + "\n" + here[1].player_name
			else:
				token_text = "\n" + here[0].player_name + "\n" + here[1].player_name + "\n+" + str(here.size() - 2)
		cell_labels[i].text = base + token_text
		cell_labels[i].add_theme_font_size_override("font_size", _scaled(13) if not here.is_empty() else _scaled(14))

func _roll_dice() -> void:
	roll_button.disabled = true
	var result := game.roll_and_move()
	if result.is_empty(): return
	dice_label.text = "🎲  " + str(result.roll)
	_refresh_tokens()
	await get_tree().create_timer(0.35).timeout
	_show_question(result.category, result.winner)

func _show_question(category: String, winner: bool) -> void:
	current_question = game.question_for_current(category)
	if current_question.is_empty(): return

	var overlay := ColorRect.new()
	overlay.color = Color(0.02, 0.04, 0.1, 0.72)
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(overlay)

	question_panel = PanelContainer.new()
	question_panel.set_anchors_preset(Control.PRESET_CENTER)
	question_panel.set_offsets_preset(Control.PRESET_CENTER, Control.PRESET_MODE_MINSIZE)
	question_panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
	question_panel.grow_vertical = Control.GROW_DIRECTION_BOTH
	question_panel.custom_minimum_size = Vector2(_scaled(480), _scaled(420))
	question_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	question_panel.add_theme_stylebox_override("panel", _panel_style(Color("#111827")))
	overlay.add_child(question_panel)

	var question_scroll := ScrollContainer.new()
	question_scroll.custom_minimum_size = Vector2(_scaled(440), _scaled(380))
	question_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	question_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	question_panel.add_child(question_scroll)

	question_content = VBoxContainer.new()
	question_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	question_content.add_theme_constant_override("separation", _scaled(10))
	question_scroll.add_child(question_content)

	var player := game.current_player()
	question_content.add_child(_label(player.emoji + "  " + player.player_name + "  •  " + category, 20, Color("#facc15")))

	var about_country := Localization.t("country_poland") if player.country == "Ukraine" else Localization.t("country_ukraine")
	question_content.add_child(_label(Localization.t("question_about", [about_country]), 15, ACCENT))
	question_content.add_child(_label(current_question.prompt, 22, TEXT))

	if current_question.type == "choice":
		for answer in current_question.answers:
			var answer_text: String = answer
			var b := _button(answer_text, func() -> void: _choose_answer(answer_text))
			b.custom_minimum_size.y = _scaled(42)
			question_content.add_child(b)
	else:
		question_content.add_child(_label(Localization.t("question_discuss"), 16, MUTED))
		var done := _button(Localization.t("question_done"), func() -> void: _answer_open_task())
		question_content.add_child(done)

func _choose_answer(answer: String) -> void:
	selected_answer = answer
	for child in question_content.get_children():
		if child is Button: child.disabled = true
	var correct: bool = answer == current_question.correct_text
	var result_text := Localization.t("question_correct") if correct else Localization.t("question_wrong", [current_question.correct_text])
	var result := _label(result_text, 18, SUCCESS if correct else ERROR)
	question_content.add_child(result)
	_add_continue_button()

func _answer_open_task() -> void:
	for child in question_content.get_children():
		if child is Button: child.disabled = true
	question_content.add_child(_label(Localization.t("question_nice"), 18, SUCCESS))
	_add_continue_button()

func _add_continue_button() -> void:
	var continue_button := _button(Localization.t("question_continue"), func() -> void: _finish_question())
	continue_button.name = "ContinueButton"
	question_content.add_child(continue_button)

func _finish_question() -> void:
	if is_instance_valid(question_panel) and is_instance_valid(question_panel.get_parent()):
		var overlay := question_panel.get_parent()
		overlay.hide()
		overlay.call_deferred("queue_free")
	var finished_player := game.current_player()
	if finished_player != null and finished_player.position >= GameManager.FINISH_POSITION:
		_show_victory(finished_player)
		return
	game.next_turn(); _update_game_ui()

func _show_victory(winner: Player) -> void:
	_clear()
	var root := _make_root()
	root.alignment = BoxContainer.ALIGNMENT_CENTER
	screen.add_child(root)
	root.add_child(_label(Localization.t("victory_title"), 40, Color("#facc15")))
	root.add_child(_label(winner.emoji + "  " + winner.player_name, 30, TEXT))
	root.add_child(_label(Localization.t("victory_reached"), 20, ACCENT))
	root.add_child(_label(Localization.t("victory_learned"), 17, MUTED))
	var gap := Control.new()
	gap.custom_minimum_size.y = _scaled(12)
	root.add_child(gap)
	root.add_child(_button(Localization.t("victory_play_again"), _show_setup))
	root.add_child(_button(Localization.t("victory_menu"), _show_menu))
