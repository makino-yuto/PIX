extends Node

# 画面のロード
var game_scene: PackedScene = preload("res://scenes/map_1.tscn")
var main_scene: PackedScene = preload("res://scenes/mainmenu.tscn")

# Gameシーンに切り替え
func load_game_scene() -> void:
	get_tree().change_scene_to_packed(game_scene)

# Mainシーンに切り替え
func load_main_scene() -> void:
	get_tree().change_scene_to_packed(main_scene)
