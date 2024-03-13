extends Control
#Creates the vars for each Bus ID called by the slider later
@onready var Master_Bus_ID = AudioServer.get_bus_index("Master")
@onready var Music_Bus_ID = AudioServer.get_bus_index("Music")
@onready var SFX_Bus_ID = AudioServer.get_bus_index("SFX")

func _on_main_vol_slider_value_changed(value):
	var db_value = linear_to_db(value) if value > 0 else -80
	AudioServer.set_bus_volume_db(Master_Bus_ID, db_value)
	AudioServer.set_bus_mute(Master_Bus_ID, value < 0.01)

func _on_music_vol_slider_value_changed(value):
	var db_value = linear_to_db(value) if value > 0 else -80
	AudioServer.set_bus_volume_db(Music_Bus_ID, db_value)
	AudioServer.set_bus_mute(Music_Bus_ID, value < 0.01)

func _on_sfx_vol_slider_value_changed(value):
	var db_value = linear_to_db(value) if value > 0 else -80
	AudioServer.set_bus_volume_db(SFX_Bus_ID, db_value)
	AudioServer.set_bus_mute(SFX_Bus_ID, value < 0.01)

# back button, returns player to the main menu
func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menu/main_menu.tscn")