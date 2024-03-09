extends Node2D
class_name Capsule

const RIGHT_EDGE : int = 7
const LEFT_EDGE : int = 0
const FLOOR : int = 15

var max_left : int = 0
var max_right : int = 6
var max_down : int = 15
var current_grid : Vector2 = Vector2.ZERO

@onready var ticker: Timer = $Ticker
@onready var left_marker: Marker2D = $LeftMarker
@onready var right_marker: Marker2D = $RightMarker

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_tick_speed()
	self.frame = choose_random_piece()

func _input(event: InputEvent) -> void:  # player input events
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
	current_grid = Grid.position_to_grid(position) # track location at all times

# move and rotate functions
func move_left() -> void:
	position.x -= 16

func move_right() -> void:
	position.x += 16

func move_down() -> void:
	var movement_options : Dictionary = check_on_grid(position)
	if movement_options["down"]:
		position.y += 16

func rotate_ccw() -> void:
	rotation_degrees -= 90
	if rotation_degrees == -360 or rotation_degrees == 360:
		rotation_degrees = 0

	# prevent from going off the right edge
	if rotation_degrees == 0:
		max_right -= 1
		if current_grid.x >= RIGHT_EDGE:
			position.x -= 16
	else:
		max_right = RIGHT_EDGE

	# prevent from going off the left edge
	if rotation_degrees == -180:
		max_left += 1
		if current_grid.x <= LEFT_EDGE:
			position.x += 16
	else:
		max_left = LEFT_EDGE

	# prevent from going off the bottom
	if rotation_degrees == -270:
		max_down -= 1
	else:
		max_down = FLOOR


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

	return {
		"left": can_move_left,
		"right": can_move_right,
		"down": can_move_down
	}

# signal functions
func _on_ticker_timeout() -> void:
	move_down()
