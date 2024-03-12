extends Node2D

@onready var gameboard_loc = $LevelLoader.global_position
var available_levels : Array = []
var loaded_levels : Array = []
var current_level_instance = null
var level_index : int = 0 # Start with level 1

func _ready() -> void:
	count_available_levels()
	load_levels()
	start_level(level_index) # Start with the first level

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("debug_next_level"):
		load_next_level()

func start_level(level_index : int):
	if current_level_instance:
		remove_child(current_level_instance)
		current_level_instance.queue_free()

	var level = loaded_levels[level_index]
	var new_level_instance = level.instantiate()
	new_level_instance.global_position = gameboard_loc
	add_child(new_level_instance)
	current_level_instance = new_level_instance

func load_next_level():
	level_index += 1
	if level_index >= loaded_levels.size():
		print("No more levels.")
		return # TODO handle finishing the game here. load a you win maybe.

	start_level(level_index)

func count_available_levels():
	var dir = DirAccess.open("res://levels")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tscn"):
				available_levels.append(file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		printerr("Failed to access levels directory.")

func load_levels():
	for i in range(available_levels.size()):
		var level_path = "res://levels/level%d.tscn" % (i + 1)
		var level = load(level_path)
		if level:
			loaded_levels.append(level)
		else:
			printerr("Failed to load level at path: %s" % level_path)
