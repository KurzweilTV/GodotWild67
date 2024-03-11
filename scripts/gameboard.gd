extends Node2D
class_name Gameboard

var active_pieces : int
var capsule_scene = preload("res://scenes/capsule.tscn")
var dummy_parasite_scene = preload("res://scenes/DummyParasite.tscn")
var pellet_scene = preload("res://scenes/Pellet.tscn")
var spawn_point_1 = Grid.grid_to_position(Vector2(3, 0))
var spawn_point_2 = Grid.grid_to_position(Vector2(4, 0))

func _ready() -> void:
	spawn_piece()
	Grid.connect("line_cleared", Callable(self, "_on_line_cleared"))
	spawn_parasites()

func _process(_delta: float) -> void:
	spawn_parasites()
	spawn_pellets()

func spawn_piece() -> void:
	var capsule1 = capsule_scene.instantiate()
	var capsule2 = capsule_scene.instantiate()
	capsule1.position = spawn_point_1
	capsule2.position = spawn_point_2

	capsule1.set_pair_capsule(capsule2)
	capsule1.is_leader = true
	capsule2.will_rotate = true

	add_child(capsule1)
	add_child(capsule2)

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

# signal functions
func _on_line_cleared() -> void:
	$Sounds/clear_sound.play()

