extends Node

static var next_id = 0
var id:int = -1

@export_range(0, 1000) var value: int = 0
@export_color_no_alpha var color: Color
var chip_textures: Array[TextureRect] = []
var label_value: Label

func _ready():
	id = get_new_id()
	find_all_texture_rects(self)
	find_label_in_button(self)
	if label_value:
		label_value.text = str(value)
	change_chip_color(color)

func get_value() -> int:
	return value

func get_color() -> Color:
	return color

func find_all_texture_rects(node):
	for child in node.get_children():
		if child is TextureRect:
			chip_textures.append(child)
		else:
			find_all_texture_rects(child)

func find_label_in_button(node):
	for child in node.get_children():
		if child is Button:
			for button_child in child.get_children():
				if button_child is Label:
					label_value = button_child
		else:
			find_label_in_button(child)

func change_chip_color(new_color: Color):
	for chip in chip_textures:
		chip.modulate = new_color

func get_new_id() -> int:
	var new_id = next_id
	next_id += 1
	return new_id
