extends Node2D
class_name Gameboard

var active_pieces : int
var capsule_scene = preload("res://scenes/capsule.tscn")
var spawn_point_1 = Grid.grid_to_position(Vector2(3, 0))
var spawn_point_2 = Grid.grid_to_position(Vector2(4, 0))

func _ready() -> void:
	spawn_piece()

func _process(delta: float) -> void:
	if active_pieces <= 0:
		spawn_piece()

func spawn_piece() -> void:
	var capsule1 = capsule_scene.instantiate()
	var capsule2 = capsule_scene.instantiate()
	capsule1.position = spawn_point_1
	capsule2.position = spawn_point_2

	capsule1.set_pair_capsule(capsule2)

	add_child(capsule1)
	add_child(capsule2)

func add_piece() -> void:
	active_pieces += 1
	print_debug(active_pieces)

func remove_piece() -> void:
	active_pieces -= 1
	print_debug(active_pieces)
