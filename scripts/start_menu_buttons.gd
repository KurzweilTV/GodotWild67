extends Control
#This script controls the start menu buttons.
@onready var hover: AudioStreamPlayer = $Hover
@onready var fwd: AudioStreamPlayer = $Fwd
@onready var back: AudioStreamPlayer = $Back


func _on_start_game_pressed():
	MusicPlayer.menu_music.stop()
	fwd.play()
	get_tree().change_scene_to_file("res://scenes/main.tscn")

# Button that moves to the options menu
func _on_options_pressed():
	fwd.play()
	get_tree().change_scene_to_file("res://scenes/menu/options.tscn")

# Button that closes the game
func _on_quit_pressed(): #Press the button to close the game
	fwd.play()
	get_tree().quit()




func _on_mouse_entered() -> void:
	hover.play()
