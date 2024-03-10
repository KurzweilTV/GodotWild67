extends Node2D
class_name Capsule

const RIGHT_EDGE : int = 7
const LEFT_EDGE : int = 0
const FLOOR : int = 16

var gameboard
var pair_capsule
var will_rotate : bool = false
var is_active_piece : bool = true
var delay : bool = false
var piece_color : String
var max_left : int = 0
var max_right : int = 7
var max_down : int = 16
var current_cycle : int = 0

@onready var ticker: Timer = $Ticker

func _ready() -> void:
	gameboard = get_parent()
	update_tick_speed()
	randomize_piece()
	register_with_gameboard()

func _input(event: InputEvent) -> void:  # player input events
	if not is_active_piece:
		return
	if event.is_action_pressed("left"):
		move_left()
	if event.is_action_pressed("right"):
		move_right()
	if event.is_action_pressed("slam"):
		move_down()
	if event.is_action_pressed("rotate"):
		rotate_ccw()

func _process(_delta: float) -> void:
	pass

# move and rotate functions
func move_left() -> void:
	if delay:
		await get_tree().create_timer(0.01).timeout # Shitty Hack
	var new_position = position + Vector2(-16, 0)
	var grid_pos = Grid.position_to_grid(new_position)
	if not Grid.is_cell_occupied(grid_pos) and pair_capsule != null and Grid.position_to_grid(pair_capsule.position) != grid_pos:
		position.x -= 16

func move_right() -> void:
	var new_position = position + Vector2(16, 0)
	var grid_pos = Grid.position_to_grid(new_position)
	if not Grid.is_cell_occupied(grid_pos) and pair_capsule != null and Grid.position_to_grid(pair_capsule.position) != grid_pos:
		position.x += 16

func move_down() -> void:
	if not is_active_piece:
		return

	var new_position = position + Vector2(0, 16)
	var grid_pos = Grid.position_to_grid(new_position)

	# Check if the next position is the floor or an already solidified piece
	if grid_pos.y >= max_down or Grid.is_cell_occupied(grid_pos):
		lock_piece()
	else:
		# If there's no collision, move the capsule down
		position.y += 16
		ticker.wait_time = 1 # reset ticker to avoid double moves
		ticker.start()


func rotate_ccw() -> void:
	var rotations : Dictionary = {
		1: Vector2(-16, -16),  # Move left and up
		2: Vector2(-16, 16),   # Move left and down
		3: Vector2(16, 16),    # Move right and down
		4: Vector2(16, -16),   # Move right and up
	}

	if will_rotate:
		current_cycle += 1
		if current_cycle > 4:
			current_cycle = 1
		position += rotations[current_cycle]
		print("Current cycle: ", current_cycle)

# setup functions
func randomize_piece() -> void:
	var frames = $Sprite.hframes
	var selected_frame = randi_range(0, frames - 1)
	$Sprite.frame = selected_frame

	match selected_frame:
		0:
			piece_color = "Red"
		1:
			piece_color = "Blue"
		2:
			piece_color = "Yellow"
		_:
			piece_color = "Unknown"
			printerr("This shouldn't happen. Ever")

func set_pair_capsule(other_capsule: Capsule) -> void:
	pair_capsule = other_capsule
	other_capsule.pair_capsule = self

func update_tick_speed() -> void: # faster drops based on game_level
	var base_speed : float = 1.0
	var max_speed : float = 0.1
	var new_speed: float = lerp(base_speed, max_speed, float(GameManager.game_level - 1) / 8.0)
	ticker.wait_time = new_speed

func register_with_gameboard() -> void:
	gameboard.add_piece()

func deregister_with_gameboard() -> void:
	gameboard.remove_piece()

# checks
func check_wall_collision() -> void:
	if position.x - 16 < LEFT_EDGE:
		pass

func check_floor_collision() -> void:
	if position.y + 16 >= FLOOR:  # Check if bottom edge reaches floor
		lock_piece()

func lock_piece() -> void:
	Grid.set_cell_occupied(Grid.position_to_grid(position), self)
	is_active_piece = false
	if pair_capsule != null and pair_capsule.is_active_piece:
		pair_capsule.lock_piece_without_propagation()  # Lock the pair without propagating back
	deregister_with_gameboard()

func lock_piece_without_propagation() -> void:
	# Similar to lock_piece but without calling lock_piece on the paired capsule again
	Grid.set_cell_occupied(Grid.position_to_grid(position), self)
	is_active_piece = false
	deregister_with_gameboard()


# signal functions
func _on_ticker_timeout() -> void:
	move_down()
