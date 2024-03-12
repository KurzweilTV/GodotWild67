extends Node

func _ready() -> void:
	randomize()

var game_level : int = 1
var game_score : int = 0

func add_score(amount : int):
	game_score += amount
	print(game_score)
