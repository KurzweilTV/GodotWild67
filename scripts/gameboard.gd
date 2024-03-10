extends Node2D

var capsule_scene = preload("res://scenes/capsule.tscn")
var spawn_point_1 = Grid.grid_to_position(Vector2(3, 0))
var spawn_point_2 = Grid.grid_to_position(Vector2(4, 0))

func _ready() -> void:
	spawn_piece()

func spawn_piece() -> void:
	var capsule1 = capsule_scene.instantiate()
	var capsule2 = capsule_scene.instantiate()
	capsule1.position = spawn_point_1
	capsule2.position = spawn_point_2
	add_child(capsule1)
	add_child(capsule2)

