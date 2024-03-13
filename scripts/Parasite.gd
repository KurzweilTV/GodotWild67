extends Node2D
# This parasite piece is used to visually create the gameboard for each level
var piece_type : Dictionary
@export_group("Map Tools")
@export_enum("Red", "Blue", "Yellow", "Random") var virus_color: String

func _ready() -> void:
	virus_color = virus_color.to_lower()
	var grid_slot = Grid.position_to_grid(position)
	if virus_color == "random" or virus_color == "" or virus_color == null:
		var random_frame = randi_range(0, 5)
		$AnimatedSprite2D.frame = random_frame

		match random_frame:
			0: piece_type = {"parasite":"blue"}
			1: piece_type = {"parasite":"blue"}
			2: piece_type = {"parasite":"red"}
			3: piece_type = {"parasite":"red"}
			4: piece_type = {"parasite":"yellow"}
			5: piece_type = {"parasite":"yellow"}
	else:
		piece_type = {"parasite":virus_color}

	Grid.set_cell_occupied(grid_slot, piece_type)
	queue_free()
