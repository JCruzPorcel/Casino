extends HBoxContainer

@export_category("Chip prefab")
@export var chip_prefab:PackedScene
@export_category("Chip prefab settings")
@export var chip_size:Vector2
@export var value_color_mapping:Array[Color]

var chip_selected
signal selected_chip_changed(new_chip)

func set_selected_chip(chip):
	if chip == chip_selected:
		return
	
	chip_selected = chip
	selected_chip_changed.emit(chip)

func is_chip_selected(chip)-> bool:
	return chip == chip_selected

func get_selected_chip() -> Node: 
	return chip_selected

func get_chip_prefab()-> PackedScene:
	return chip_prefab

func get_chip_size()-> Vector2:
	return chip_size

func get_value_color_mapping()-> Array[Color]:
	return value_color_mapping
