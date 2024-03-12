extends Node

var available_levels : Array = []

func _ready() -> void:
	randomize()
	print(available_levels)

var game_level : int = 0
var game_score : int = 0

func add_score(amount : int):
	game_score += amount
	print(game_score)
