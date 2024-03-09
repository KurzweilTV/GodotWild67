extends Node2D

@onready var ticker: Timer = $Ticker


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_tick_speed()
	$Sprite2D.frame = choose_random_piece()

func _input(event: InputEvent) -> void: # player input events
	if event.is_action_pressed("left"):
		move_left()
	if event.is_action_pressed("right"):
		move_right()
	if event.is_action_pressed("slam"):
		move_down()
	if event.is_action_pressed("rotate"):
		rotate_ccw()

# move and rotate functions
func move_left() -> void:
	position.x -= 16
	
func move_right() -> void:
	position.x += 16
	
func move_down() -> void:
	position.y += 16
	
func rotate_ccw() -> void:
	rotation_degrees -= 90

func update_tick_speed() -> void: # faster drops based on game_level
	var base_speed : float = 1.0
	var max_speed : float = 0.1
	
	var new_speed: float = lerp(base_speed, max_speed, float(GameManager.game_level - 1) / 8.0)
	ticker.wait_time = new_speed
	
func choose_random_piece() -> int:
	var sprite : Sprite2D = $Sprite2D
	var frame_count : int = sprite.hframes
	var rand_frame : int = randi_range(1, frame_count) - 1
	return rand_frame
	
	

# signal functions
func _on_ticker_timeout() -> void:
	move_down()
