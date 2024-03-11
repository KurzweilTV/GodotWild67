extends Node2D
class_name Capsule

const RIGHT_EDGE : int = 7
const LEFT_EDGE : int = 0
const FLOOR : int = 16

var gameboard
var pair_capsule
var is_leader : bool = false
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

func can_move_to(new_position: Vector2, pair_new_position: Vector2) -> bool:
	var grid_pos = Grid.position_to_grid(new_position)
	var pair_grid_pos = Grid.position_to_grid(pair_new_position)
	return not Grid.is_cell_occupied(grid_pos) and not Grid.is_cell_occupied(pair_grid_pos)

func move_left() -> void:
	if is_leader:
		var new_position = position + Vector2(-16, 0)
		var pair_new_position = pair_capsule.position + Vector2(-16, 0)
		if can_move_to(new_position, pair_new_position):
			position = new_position
			pair_capsule.position = pair_new_position
			$Sounds/move_sound.play()

# Adjusted move_right function
func move_right() -> void:
	if is_leader:
		var new_position = position + Vector2(16, 0)
		var pair_new_position = pair_capsule.position + Vector2(16, 0)
		if can_move_to(new_position, pair_new_position):
			position = new_position
			pair_capsule.position = pair_new_position
			$Sounds/move_sound.play()

# Adjusted move_down function
func move_down() -> void:
	if not is_active_piece:
		return
	var new_position = position + Vector2(0, 8)  # Half grid move down
	var pair_new_position = pair_capsule.position + Vector2(0, 8)

	if can_move_to(new_position, pair_new_position):
		position = new_position
		pair_capsule.position = pair_new_position
	else:
		# Before locking, adjust position to align with grid if necessary
		align_with_grid()
		lock_pieces()

func align_with_grid():
	# Align the position to the nearest grid spot above to prevent sinking into objects.
	position.y = floor(position.y / 16) * 16
	pair_capsule.position.y = floor(pair_capsule.position.y / 16) * 16

func rotate_ccw() -> void:
	var rotations: Dictionary = {
		1: Vector2(-16, -16),  # Move left and up
		2: Vector2(-16, 16),   # Move left and down
		3: Vector2(16, 16),    # Move right and down
		4: Vector2(16, -16),   # Move right and up
	}

	update_tick_speed()

	if will_rotate:
		current_cycle += 1
		if current_cycle > 4:
			current_cycle = 1

		position += rotations[current_cycle]
		$Sounds/rotate_sound.play()
		nudge_towards_center() # if piece rotation isn't valid
		update_tick_speed()

#func animate_rotation(rotation_offset: Vector2) -> void:
	#var final_position = position + rotation_offset
	#var tween = create_tween()
	#tween.tween_property(self, "position", final_position, 0.1)
	#tween.connect("finished", Callable(self, "_on_tween_finished"))

func nudge_towards_center() -> void:
	var nudge_direction = Vector2.ZERO
	var grid_pos = Grid.position_to_grid(position)
	var should_nudge_down = false

	# Handle board edges for horizontal nudging
	if grid_pos.x < LEFT_EDGE:
		nudge_direction.x = 1
	elif grid_pos.x > RIGHT_EDGE:
		nudge_direction.x = -1

	# Check for occupation and decide on nudging direction
	if Grid.is_cell_occupied(grid_pos):
		match current_cycle:
			1:
				nudge_direction.y = 1  # Nudge down for specific rotation state
			2:
				nudge_direction.x = 1  # Nudge right
			3: #HACK This is bad and I hate it.
				rotate_ccw()
				rotate_ccw()
				rotate_ccw()
				lock_pieces()
				return
			4:
				nudge_direction.x = -1  # Nudge left

	# horizontal nudge if somethins is there
	if nudge_direction.x != 0:
		position.x += nudge_direction.x * 16
		if pair_capsule != null:
			pair_capsule.position.x += nudge_direction.x * 16

	# vertical nudge of we hit the roof or a gamepiece
	if nudge_direction.y != 0:
		position.y += nudge_direction.y * 16
		if pair_capsule != null:
			pair_capsule.position.y += nudge_direction.y * 16

func lock_pieces():
	Grid.set_cell_occupied(Grid.position_to_grid(position), self)
	Grid.set_cell_occupied(Grid.position_to_grid(pair_capsule.position), pair_capsule)
	is_active_piece = false
	pair_capsule.is_active_piece = false
	gameboard.spawn_piece()

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
	ticker.stop()
	var base_speed : float = 1.0
	var max_speed : float = 0.1
	var new_speed: float = lerp(base_speed, max_speed, float(GameManager.game_level - 1) / 8.0)
	ticker.wait_time = new_speed
	ticker.start()

# checks
func check_floor_collision() -> void:
	if position.y + 16 >= FLOOR:  # Check if bottom edge reaches floor
		lock_pieces()

# signal functions
func _on_ticker_timeout() -> void:
	move_down()
