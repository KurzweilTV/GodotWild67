extends Node2D

@onready var art := $Sprite2D
var parasite_color
var piece_type : Dictionary = {}

func _ready() -> void:
	piece_type = {"parasite":parasite_color}
	match parasite_color:
		"red": art.frame = 0
		"blue": art.frame = 1
		"yellow": art.frame = 2
