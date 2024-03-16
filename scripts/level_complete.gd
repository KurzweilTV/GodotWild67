extends Node2D


func _unhandled_input(event: InputEvent) -> void:
	self.queue_free()
