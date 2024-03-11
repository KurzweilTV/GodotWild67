extends Node2D

var piece_type : Dictionary

func _ready() -> void:
	var random_frame = randi_range(0, 2)
	$AnimatedSprite2D.frame = random_frame
	var grid_slot = Grid.position_to_grid(position)

	match random_frame:
		0: piece_type = {"parasite":"blue"}
		1: piece_type = {"parasite":"red"}
		2: piece_type = {"parasite":"yellow"}

	Grid.set_cell_occupied(grid_slot, piece_type)
