extends Node2D

func _ready() -> void:
	$PauseSound.play()
	global_position = Vector2(320, 240)



func _on_resume_pressed() -> void:
	get_tree().paused = false
	self.queue_free()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_button_mouse_entered() -> void:
	$HoverSound.play()
