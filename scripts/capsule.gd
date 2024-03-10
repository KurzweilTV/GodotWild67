extends Node2D
class_name Capsule

const RIGHT_EDGE : int = 7
const LEFT_EDGE : int = 0
const FLOOR : int = 16

var gameboard
var is_active_piece : bool = true
var piece_color : String
var max_left : int = 0
var max_right : int = 7
var max_down : int = 15

@onready var ticker: Timer = $Ticker

func _ready() -> void:
	var gameboard = get_parent()
	update_tick_speed()
	randomize_piece()
	register_with_gameboard()
	print_debug("My color is ", piece_color)

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
	position.x -= 16

func move_right() -> void:
	position.x += 16

func move_down() -> void:
	if not is_active_piece:
		return

	var new_position = position + Vector2(0, 16)
	var grid_pos = Grid.position_to_grid(new_position)
	if not Grid.is_cell_occupied(grid_pos):
		position.y += 16
	else:
		lock_piece()  # Lock if collision occurs

func rotate_ccw() -> void:
	pass

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


func update_tick_speed() -> void: # faster drops based on game_level
	var base_speed : float = 1.0
	var max_speed : float = 0.1
	var new_speed: float = lerp(base_speed, max_speed, float(GameManager.game_level - 1) / 8.0)
	ticker.wait_time = new_speed

func register_with_gameboard() -> void:
	if gameboard and gameboard.has_method("add_piece"):
		gameboard.add_piece(self)
	else:
		pass
		#printerr("The parent is not a gameboard or does not have an add_piece method.")


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
	gameboard.remove_piece(self)

# signal functions
func _on_ticker_timeout() -> void:
	move_down()
