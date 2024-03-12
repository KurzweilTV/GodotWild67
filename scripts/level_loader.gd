extends Node2D
# This script handles loading each level into the game
@onready var gameboard_loc = %LevelLoader.global_position
var available_levels : Array = []
var loaded_levels : Array = []
var level_count : int = 0

func _ready() -> void:
	count_available_levels()

func count_available_levels():
	var dir = DirAccess.open("res://levels")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			available_levels.append(file_name)
			file_name = dir.get_next()
		level_count = available_levels.size()
		print("We found %d levels" % level_count)
		load_levels(level_count)
	else:
		print("An error occurred when trying to access the path.")

func load_levels(count_number):
	for i in range(1, count_number + 1):
		var level_path = "res://levels/level%d.tscn" % i
		GameManager.available_levels.append(level_path)
	return loaded_levels
