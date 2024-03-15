extends Node2D

func _ready() -> void:
	if !MusicPlayer.menu_music.is_playing():
		MusicPlayer.play_menu_music()
	get_tree().paused = false

