extends Node2D

@onready var bgmusic = $AudioStreamPlayer2D

# Here for testing of audio player. Should be removed when music is set on the autoloader.
func _on_audio_stream_player_2d_finished():
	bgmusic.play()

