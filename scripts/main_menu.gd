extends Node2D
#script controls background music

@onready var bgmusic = $AudioStreamPlayer2D

func _on_audio_stream_player_2d_finished():
	bgmusic.play()
