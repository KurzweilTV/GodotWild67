extends Node2D

var active_pieces : Array
var capsule_scene = preload("res://scenes/capsule.tscn")
var spawn_point_1 = Grid.grid_to_position(Vector2(3, 0))
var spawn_point_2 = Grid.grid_to_position(Vector2(4, 0))

func _ready() -> void:
	spawn_piece()

func _process(delta: float) -> void:
	if active_pieces.is_empty():
		spawn_piece()

func spawn_piece() -> void:
	var capsule1 = capsule_scene.instantiate()
	var capsule2 = capsule_scene.instantiate()
	capsule1.position = spawn_point_1
	capsule2.position = spawn_point_2
	add_child(capsule1)
	add_child(capsule2)

func add_piece(piece) -> void:
	active_pieces.append(piece)
	print_debug(active_pieces)

func remove_piece(piece) -> void:
	if piece in active_pieces:
		active_pieces.erase(piece)
	print_debug(active_pieces)
