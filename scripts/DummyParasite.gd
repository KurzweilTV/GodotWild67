extends Node2D
# This is what gets spawned on the board based on the state of the grid.

@onready var art := $Sprite2D
var parasite_color
var piece_type : Dictionary = {}

func _ready() -> void:
	piece_type = {"parasite":parasite_color}
	match parasite_color:
		"red": art.play("red")
		"blue": art.play("blue")
		"yellow": art.play("yellow")
