extends Node2D

@onready var score_label: Label = $Score

func _ready() -> void:
	score_label.text = str(GameManager.game_score)
	MusicPlayer.game_music.stop()


func _on_menu_pressed() -> void:
	Grid._initialize_grid()
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")


