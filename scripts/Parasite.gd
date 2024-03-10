extends Node2D

func _ready() -> void:
	$AnimatedSprite2D.frame = randi_range(0, 2)
	var grid_slot = Grid.position_to_grid(position)
	Grid.set_cell_occupied(grid_slot, self)
