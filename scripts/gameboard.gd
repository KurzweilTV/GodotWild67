extends Node2D

var capsule_scene = preload("res://scenes/capsule.tscn")
var spawn_point = Grid.grid_to_position(Vector2(3, 0))

func _ready() -> void:
	spawn_piece()

func spawn_piece() -> void:
	var capsule = capsule_scene.instantiate()
	add_child(capsule)
	capsule.position = spawn_point
