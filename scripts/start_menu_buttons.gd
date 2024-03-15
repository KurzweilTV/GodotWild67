extends Control
#This script controls the start menu buttons.


func _on_start_game_pressed():
	MusicPlayer.menu_music.stop()
	get_tree().change_scene_to_file("res://scenes/main.tscn")

# Button that moves to the options menu
func _on_options_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menu/options.tscn")

# Button that closes the game
func _on_quit_pressed(): #Press the button to close the game
	get_tree().quit()


