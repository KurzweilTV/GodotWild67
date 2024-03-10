extends Node2D
class_name Capsule

const RIGHT_EDGE : int = 7
const LEFT_EDGE : int = 0
const FLOOR : int = 16

var is_active_piece : bool = true
var max_left : int = 0
var max_right : int = 7
var max_down : int = 15
var marker_pos : Dictionary = {
	"marker1": Vector2.ZERO,
	"marker2": Vector2.ZERO
	}

@onready var ticker: Timer = $Ticker
@onready var markers: Array = [$LeftMarker, $RightMarker]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = Vector2(264,137)
	update_tick_speed()
	self.frame = choose_random_piece()

func _input(event: InputEvent) -> void:  # player input events
	if not is_active_piece:
		return

	var movement_options = check_on_grid(position)
	if event.is_action_pressed("left") and movement_options["left"]:
		move_left()
	if event.is_action_pressed("right") and movement_options["right"]:
		move_right()
	if event.is_action_pressed("slam") and movement_options["down"]:
		move_down()
	if event.is_action_pressed("rotate"):
		rotate_ccw()

func _process(_delta: float) -> void:
	if is_active_piece:
		enforce_bounds()

# move and rotate functions
func move_left() -> void:
	position.x -= 16


func move_right() -> void:
	position.x += 16

func move_down() -> void:
	if not is_active_piece:
		return
	var movement_options : Dictionary = check_on_grid(position)
	if movement_options["down"]:
		position.y += 16

func rotate_ccw() -> void:
	rotation_degrees -= 90
	if rotation_degrees == -360 or rotation_degrees == 360:
		rotation_degrees = 0
	if rotation_degrees == -90:
		position += Vector2(0, 16)
	if rotation_degrees == -180:
		position += Vector2(16, 0)
	if rotation_degrees == -270:
		position += Vector2(0, -16)
	if rotation_degrees == 0:
		position -= Vector2(16, 0)


func update_marker_pos() -> void:
	marker_pos["marker1"] = Grid.position_to_grid(markers[0].global_position)
	marker_pos["marker2"] = Grid.position_to_grid(markers[1].global_position)

func enforce_bounds() -> void:
	var adjust_position = Vector2.ZERO

	for marker_name in marker_pos.keys():
		var marker_grid_loc = marker_pos[marker_name]
		if marker_grid_loc.x < LEFT_EDGE:
			adjust_position.x = max(adjust_position.x, LEFT_EDGE - marker_grid_loc.x)
		elif marker_grid_loc.x > RIGHT_EDGE:
			adjust_position.x = min(adjust_position.x, RIGHT_EDGE - marker_grid_loc.x)
		if marker_grid_loc.y >= FLOOR:
			adjust_position.y = min(adjust_position.y, FLOOR - marker_grid_loc.y)

	var position_adjustment = Grid.grid_to_position(adjust_position) - Grid.grid_to_position(Vector2.ZERO)
	position += position_adjustment

func update_tick_speed() -> void: # faster drops based on game_level
	var base_speed : float = 1.0
	var max_speed : float = 0.1
	var new_speed: float = lerp(base_speed, max_speed, float(GameManager.game_level - 1) / 8.0)
	ticker.wait_time = new_speed

func choose_random_piece() -> int:
	var frame_count : int = self.hframes
	var rand_frame : int = randi_range(1, frame_count) - 1
	return rand_frame

func check_on_grid(pos) -> Dictionary:
	var location: Vector2 = Grid.position_to_grid(pos)
	var can_move_left: bool = true
	var can_move_right: bool = true
	var can_move_down: bool = true

	if location.x <= max_left:
		can_move_left = false
	if location.x >= max_right:
		can_move_right = false
	if location.y >= max_down:
		can_move_down = false
		lock_piece()

	return {
		"left": can_move_left,
		"right": can_move_right,
		"down": can_move_down
	}

func lock_piece() -> void:
	is_active_piece = false

# signal functions
func _on_ticker_timeout() -> void:
	move_down()
