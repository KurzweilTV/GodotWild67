extends Node2D

@onready var score_label: Label = $UI_Clipboard/Container/Score
@onready var speed_label: Label = $UI_Clipboard/Container/Speed
@onready var level_label: Label = $UI_Clipboard/Container/Level
@onready var parasites_label: Label = $UI_Clipboard/Container/Parasites

@onready var gameboard_loc = $LevelLoader.global_position

var available_levels : Array = []
var current_level_instance = null
var level_index : int = 0 # Start with level 1

var loaded_levels = [
		preload("res://levels/level1.tscn"),
		preload("res://levels/level2.tscn"),
		preload("res://levels/level3.tscn"),
		preload("res://levels/level4.tscn"),
		preload("res://levels/level5.tscn"),
		preload("res://levels/level6.tscn"),
		preload("res://levels/level7.tscn"),
		preload("res://levels/level8.tscn"),
		preload("res://levels/level9.tscn")
	]

func _ready() -> void:
	MusicPlayer.play_game_music()
	count_available_levels()
	start_level() # Start with the first level
	update_ui()

func _process(_delta: float) -> void:
	update_ui()

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("debug_next_level"):
		load_next_level()

func start_level():
	if current_level_instance:
		remove_child(current_level_instance)
		current_level_instance.queue_free()

	var level = loaded_levels[level_index]
	var new_level_instance = level.instantiate()
	new_level_instance.connect("level_complete", Callable(self, "_on_level_complete"))
	new_level_instance.global_position = gameboard_loc
	add_child(new_level_instance)
	new_level_instance.next_piece_loc = $SpawnLoc
	current_level_instance = new_level_instance

func load_next_level():
	if level_index >= loaded_levels.size():
		print("No more levels.")
		return # TODO handle finishing the game here. load a you win maybe.
	else:
		Grid._initialize_grid()
		level_index += 1
		GameManager.game_level += 1

	start_level()

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

# UI Updates
func update_ui() -> void:
	var score : int = GameManager.game_score
	var speed : String = GameManager.game_speed
	var level : int = GameManager.game_level
	var parasites : int = GameManager.game_parasites

	score_label.text = str(score)
	speed_label.text = speed
	level_label.text = str(level)
	parasites_label.text = str(parasites)

# signals
func _on_level_complete() -> void:
	load_next_level() # here is where we could load the level complete UI

func _on_gameover() -> void:
	print("GameOver!")
