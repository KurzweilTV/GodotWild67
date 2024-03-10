extends Node

var grid = []  # Nested array for grid representation
var grid_size = Vector2(8, 16)  # Store grid dimensions

func _ready():
	_initialize_grid()

func _initialize_grid():
	grid = []
	for y in range(grid_size.y):
		grid.append([])
		for x in range(grid_size.x):
			grid[y].append(null)  # Set all cells to unoccupied

func position_to_grid(pos):
	var grid_x = int(pos.x / 16)
	var grid_y = int(pos.y / 16)
	return Vector2(grid_x, grid_y)

func grid_to_position(grid_pos):
	var pixel_x = grid_pos.x * 16
	var pixel_y = grid_pos.y * 16
	return Vector2(pixel_x, pixel_y)

func is_cell_occupied(grid_pos: Vector2) -> bool:
	if grid_pos.x < 0 or grid_pos.x >= grid_size.x or grid_pos.y < 0 or grid_pos.y >= grid_size.y:
		return false

	return grid[int(grid_pos.y)][int(grid_pos.x)] != null


func set_cell_occupied(grid_pos, occupant):
	if grid_pos.x >= 0 and grid_pos.x < grid_size.x and grid_pos.y >= 0 and grid_pos.y < grid_size.y:
		grid[grid_pos.y][grid_pos.x] = occupant


func check_for_line_clears():
	print("Checked for Line Clears")
	#TODO Implement your line clearing logic here
