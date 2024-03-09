extends Node

var grid = []
var grid_width = 8
var grid_height = 16
var origin : Vector2 = Vector2(256,128)

func _ready():
	initialize_grid()

func initialize_grid():
	grid = []
	for i in range(grid_height):
		grid.append([])
		grid[i].resize(grid_width)
		for j in range(grid_width):
			grid[i][j] = null

func position_to_grid(pos):
	var grid_x = int((pos.x - origin.x) / 16)
	var grid_y = int((pos.y - origin.y) / 16)
	return Vector2(grid_x, grid_y)

func grid_to_position(grid_pos):
	var pixel_x = grid_pos.x * 16 + origin.x
	var pixel_y = grid_pos.y * 16 + origin.y
	return Vector2(pixel_x, pixel_y)
