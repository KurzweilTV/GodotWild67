extends Node2D

@export var main_menu_scene : PackedScene

func load_menu() -> void:
	get_tree().change_scene_to_packed(main_menu_scene)
