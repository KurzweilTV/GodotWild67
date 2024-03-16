extends Node

@onready var menu_music: AudioStreamPlayer = $menu_music
@onready var game_music: AudioStreamPlayer = $game_music

@onready var Master_Bus_ID = AudioServer.get_bus_index("Master")
@onready var Music_Bus_ID = AudioServer.get_bus_index("Music")
@onready var SFX_Bus_ID = AudioServer.get_bus_index("SFX")

func _ready() -> void:
	AudioServer.set_bus_volume_db(Master_Bus_ID, -2)
	AudioServer.set_bus_volume_db(Music_Bus_ID, -5)
	AudioServer.set_bus_volume_db(SFX_Bus_ID, -2)

func play_menu_music():
	$menu_music.play()

func play_game_music():
	$game_music.play()
