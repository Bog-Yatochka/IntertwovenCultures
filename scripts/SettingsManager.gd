extends Node

const AVAILABLE_RESOLUTIONS := [
	Vector2i(1280, 720),
	Vector2i(1366, 768),
	Vector2i(1600, 900),
	Vector2i(1920, 1080),
	Vector2i(2560, 1440),
	Vector2i(3840, 2160)
]

var current_resolution: Vector2i = Vector2i(1280, 720)
var is_fullscreen: bool = false

func _ready() -> void:
	load_settings()

func set_resolution(resolution: Vector2i) -> void:
	current_resolution = resolution
	apply_display_settings()
	save_settings()

func set_fullscreen(fullscreen: bool) -> void:
	is_fullscreen = fullscreen
	apply_display_settings()
	save_settings()

func apply_display_settings() -> void:
	if is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(current_resolution)
		# Center window
		var screen_size := DisplayServer.screen_get_size()
		var window_pos := (screen_size - current_resolution) / 2
		DisplayServer.window_set_position(window_pos)

func get_resolution_index() -> int:
	for i in range(AVAILABLE_RESOLUTIONS.size()):
		if AVAILABLE_RESOLUTIONS[i] == current_resolution:
			return i
	return 0

func save_settings() -> void:
	var config := ConfigFile.new()
	config.set_value("display", "resolution_x", current_resolution.x)
	config.set_value("display", "resolution_y", current_resolution.y)
	config.set_value("display", "fullscreen", is_fullscreen)
	config.save("user://settings.cfg")

func load_settings() -> void:
	var config := ConfigFile.new()
	var err := config.load("user://settings.cfg")
	if err == OK:
		var res_x: int = config.get_value("display", "resolution_x", 1280)
		var res_y: int = config.get_value("display", "resolution_y", 720)
		current_resolution = Vector2i(res_x, res_y)
		is_fullscreen = config.get_value("display", "fullscreen", false)
		apply_display_settings()
