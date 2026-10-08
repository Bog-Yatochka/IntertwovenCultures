class_name Player
extends RefCounted

var player_name: String
var country: String
var emoji: String
var position: int = 0
var token_color: Color

func _init(p_name: String, p_country: String, p_emoji: String, p_color: Color) -> void:
	player_name = p_name
	country = p_country
	emoji = p_emoji
	token_color = p_color
