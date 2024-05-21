extends Node

@export_range(0,1000) var value: int = 0
@export_color_no_alpha var color: Color
@export var chip_textures: Array[TextureRect]
@export var label_value: Label

func get_value() -> int:
	return value

func _ready():
	label_value.text = str(value)
	change_chip_color(color)

func change_chip_color(new_color: Color):
	for chip in chip_textures:
		chip.modulate = new_color
