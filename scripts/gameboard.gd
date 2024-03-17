extends Node2D

signal level_complete

@onready var label: Label = $DebugLabel

var active_pieces : int
var active_parasites : int = 0
var capsule_scene = preload("res://scenes/capsule.tscn")
var dummy_parasite_scene = preload("res://scenes/dummyparasite.tscn")
var pellet_scene = preload("res://scenes/pellet.tscn")
var gameover_scene : PackedScene = preload("res://scenes/game_over.tscn")
var spawn_point_1 = Grid.grid_to_position(Vector2(3, 0))
var spawn_point_2 = Grid.grid_to_position(Vector2(4, 0))
var parasite_count : int = 0
var next_piece_loc : Marker2D
var capsule1
var capsule2
var capsule3
var capsule4


func _ready() -> void:
	Grid.connect("line_cleared", Callable(self, "_on_line_cleared"))
	clear_capsules()
	spawn_piece()
	spawn_parasites()
	GameManager.game_parasites = Grid.update_parasite_count()
	GameManager.game_speed = set_game_speed_string()


func _process(_delta: float) -> void:
	spawn_parasites()
	spawn_pellets()

func spawn_piece() -> void:
	capsule1 = capsule_scene.instantiate()
	capsule2 = capsule_scene.instantiate()
	capsule1.piece_type = GameManager.next_1
	capsule2.piece_type = GameManager.next_2
	capsule1.name = "Piece1"
	capsule2.name = "Piece2"
	capsule1.position = spawn_point_1
	capsule2.position = spawn_point_2
	add_child(capsule1)
	add_child(capsule2)

	capsule1.connect("piece_locked", Callable(self, "_on_piece_locked"))
	capsule2.connect("piece_locked", Callable(self, "_on_piece_locked"))
	capsule1.connect("gameover", Callable(self, "_on_gameover"))
	capsule2.connect("gameover", Callable(self, "_on_gameover"))

	capsule1.set_pair_capsule(capsule2)
	capsule1.is_leader = true
	capsule2.will_rotate = true

	spawn_next()

func spawn_next() -> void:
	if capsule3:
		capsule3.queue_free()
	if capsule4:
		capsule4.queue_free()

	capsule3 = capsule_scene.instantiate()
	capsule4 = capsule_scene.instantiate()
	add_child(capsule3)
	add_child(capsule4)

	capsule3.connect("piece_locked", Callable(self, "_on_piece_locked"))
	capsule4.connect("piece_locked", Callable(self, "_on_piece_locked"))
	capsule3.connect("gameover", Callable(self, "_on_gameover"))
	capsule4.connect("gameover", Callable(self, "_on_gameover"))

	capsule3.is_active_piece = false
	capsule4.is_active_piece = false
	capsule3.name = "Next1"
	capsule4.name = "Next2"
	GameManager.next_1 = capsule3.piece_type
	GameManager.next_2 = capsule4.piece_type

	retry_set_position()

func retry_set_position() -> void:
	if not next_piece_loc:
		await get_tree().create_timer(0.1).timeout # Wait for 0.1 seconds before retrying
		retry_set_position() # Retry
	else:
		capsule3.global_position = next_piece_loc.global_position
		capsule4.global_position = next_piece_loc.global_position + Vector2(16, 0)

func retry_set_color() -> void:
	if not capsule3.piece_type and get_tree():
		await get_tree().create_timer(0.1).timeout # Wait for 0.1 seconds before retrying
		retry_set_color() # Retry
	else:
		capsule1.piece_type = capsule3.piece_type
		capsule2.piece_type = capsule4.piece_type

func clear_capsules():
	if capsule1:
		capsule1.queue_free()
	if capsule2:
		capsule2.queue_free()
	if capsule3:
		capsule3.queue_free()
	if capsule4:
		capsule4.queue_free()

# iterate on teh grid

func spawn_parasites():
	for y in range(len(Grid.grid)):
		for x in range(len(Grid.grid[y])):
			var cell = Grid.grid[y][x]
			if cell != null and "parasite" in cell and not cell.has("spawned"):
				var parasite = dummy_parasite_scene.instantiate()
				parasite.position = Grid.grid_to_position(Vector2(x, y))
				parasite.parasite_color = cell["parasite"]
				add_child(parasite)
				# Update the cell to include a reference to the spawned node
				Grid.grid[y][x] = {"parasite": cell["parasite"], "spawned": true, "node": parasite}

func spawn_pellets():
	for y in range(len(Grid.grid)):
		for x in range(len(Grid.grid[y])):
			var cell = Grid.grid[y][x]
			if cell != null and "pellet" in cell and not cell.has("spawned"):
				var pellet = pellet_scene.instantiate()
				pellet.position = Grid.grid_to_position(Vector2(x, y))
				pellet.pellet_color = cell["pellet"]
				add_child(pellet)
				Grid.grid[y][x] = {"pellet": cell["pellet"], "spawned": true, "node": pellet}

func set_game_speed_string() -> String:
	match GameManager.game_level:
		1, 2, 3:
			return "Slow"
		4, 5, 6:
			return "Medium"
		7, 8, 9:
			return "Fast"
		_:
			return "Unknown"  # If we see this, we fucked up.


# signal functions
func _on_line_cleared() -> void:
	$Sounds/clear_sound.play()
	GameManager.game_parasites = Grid.update_parasite_count()
	if GameManager.game_parasites == 0:
		emit_signal("level_complete")

func _on_gameover() -> void:
	var gameover_instance = gameover_scene.instantiate()
	add_child(gameover_instance)
	gameover_instance.global_position = Vector2(320,240)
	get_tree().paused = true
	if GameManager.silly_mode:
		$Sounds/gameover_sound.pitch_scale = 1.2
		$Sounds/gameover_sound.play()
	else: $Sounds/gameover_sound.play()

func _on_piece_locked() -> void:
	GameManager.game_parasites = Grid.update_parasite_count()
	$Sounds/lock_sound.play()
