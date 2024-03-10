extends Node2D
class_name Capsule

const RIGHT_EDGE : int = 7
const LEFT_EDGE : int = 0
const FLOOR : int = 16

var is_active_piece : bool = true
var max_left : int = 0
var max_right : int = 7
var max_down : int = 15

@onready var ticker: Timer = $Ticker

func _ready() -> void:
	update_tick_speed()

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

func update_tick_speed() -> void: # faster drops based on game_level
	var base_speed : float = 1.0
	var max_speed : float = 0.1
	var new_speed: float = lerp(base_speed, max_speed, float(GameManager.game_level - 1) / 8.0)
	ticker.wait_time = new_speed

func check_wall_collision() -> void:
	if position.x - 16 < LEFT_EDGE:
		pass

func check_floor_collision() -> void:
	if position.y + 16 >= FLOOR:  # Check if bottom edge reaches floor
		lock_piece()

func lock_piece() -> void:
	Grid.set_cell_occupied(Grid.position_to_grid(position), true)
	is_active_piece = false
	print(Grid.grid)

# signal functions
func _on_ticker_timeout() -> void:
	move_down()
