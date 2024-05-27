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
	find_label_recursive(self)
	if label_value:
		label_value.text = str(value)
	change_chip_color(color)

func get_new_id() -> int:
	var new_id = next_id
	next_id += 1
	return new_id

func get_value() -> int:
	return value

func get_color() -> Color:
	return color

func get_label()-> Label:
	return label_value

func find_all_texture_rects(node):
	for child in node.get_children():
		if child is TextureRect:
			chip_textures.append(child)
		else:
			find_all_texture_rects(child)

func find_label_recursive(node):
	for child in node.get_children():
		if child is Label:
			label_value = child
			return
		elif child.get_child_count() > 0:
			find_label_recursive(child)

func change_chip_color(new_color: Color):
	for chip in chip_textures:
		chip.modulate = new_color

func change_chip_size(new_size: Vector2):
	self.scale = new_size
