extends Node

func _ready() -> void:
	randomize()

var game_level : int = 1
var game_score : int = 0
var game_speed : String
var game_parasites : int

func _process(_delta: float) -> void:
	Grid.update_parasite_count()

func calculate_score(parasites_cleared : int) -> int:
	if parasites_cleared < 0: parasites_cleared = 0
	var score_multiplier : int = 1
	var base_values : Dictionary = {
		0:0,
		1:100,
		2:200,
		3:400,
		4:800,
		5:1600,
		6:3200,
	}
	if game_level in [1, 2, 3]:
		score_multiplier = 1
	elif game_level in [4, 5, 6]:
		score_multiplier = 2
	else:
		score_multiplier = 3

	return base_values[parasites_cleared] * score_multiplier

func add_score(amount : int):
	game_score += amount
