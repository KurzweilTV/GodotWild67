extends Node

signal line_cleared
var grid = []  # Nested array for grid representation
var grid_size = Vector2(8, 16)  # Store grid dimensions

func _ready():
	_initialize_grid()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_print_grid"):
		print(grid)

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
	# Check if the position is out of bounds
	if grid_pos.x < 0 or grid_pos.x >= grid_size.x or grid_pos.y < 0 or grid_pos.y >= grid_size.y:
		return true

	return grid[int(grid_pos.y)][int(grid_pos.x)] != null

func set_cell_occupied(grid_pos, occupant):
	if grid_pos.x >= 0 and grid_pos.x < grid_size.x and grid_pos.y >= 0 and grid_pos.y < grid_size.y:
		grid[grid_pos.y][grid_pos.x] = occupant

# match handling section
func find_and_clear_matches():
	check_every_row()
	check_every_column()

func check_every_row():
	for y in range(len(grid)):
		var row = grid[y]
		var current_sequence_length = 1
		var current_value = null

		for x in range(len(row)):
			var cell = row[x]
			var value = null
			if cell != null and cell.size() > 0:
				value = cell.values()[0]

			if x > 0 and value == current_value:
				current_sequence_length += 1
			else:
				if current_sequence_length >= 4 and current_value != null: # We found a match!
					# Clear the sequence
					for clear_x in range(x - current_sequence_length, x): # Where the cells get cleared
						set_cell_occupied(Vector2(clear_x, y), null)
					emit_signal("line_cleared")
				current_sequence_length = 1

			current_value = value

			# Check at the end of the row if the last sequence was long enough
			if x == len(row) - 1 and current_sequence_length >= 4 and current_value != null:
				# Clear the sequence
				for clear_x in range(x - current_sequence_length + 1, x + 1):
					set_cell_occupied(Vector2(clear_x, y), null)
				emit_signal("line_cleared")

func check_every_column():
	for x in range(grid_size.x):
		var current_sequence_length = 1
		var current_value = null

		for y in range(grid_size.y):
			var cell = grid[y][x]  # Slightly different than the one above
			var value = null
			if cell != null and cell.size() > 0:
				value = cell.values()[0]

			if y > 0 and value == current_value:
				current_sequence_length += 1
			else:
				if current_sequence_length >= 4 and current_value != null:
					for clear_y in range(y - current_sequence_length, y):
						set_cell_occupied(Vector2(x, clear_y), null)
					emit_signal("line_cleared")
				current_sequence_length = 1

			current_value = value

			if y == grid_size.y - 1 and current_sequence_length >= 4 and current_value != null: # We found a match!
				for clear_y in range(y - current_sequence_length + 1, y + 1):
					set_cell_occupied(Vector2(x, clear_y), null) # Where the cells get cleared
				emit_signal("line_cleared")




