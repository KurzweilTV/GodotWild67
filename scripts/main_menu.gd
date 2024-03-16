extends Node2D

func _ready() -> void:
	GameManager.reset_gamestate()
	if !MusicPlayer.menu_music.is_playing():
		MusicPlayer.play_menu_music()
	get_tree().paused = false

