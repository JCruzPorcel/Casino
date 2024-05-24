extends HBoxContainer
 
@export var chip_prefab:PackedScene
@export var chip_size:Vector2

var chip_selected
signal selected_chip_changed(new_chip)

func set_selected_chip(chip):
	if chip == chip_selected:
		return
	
	chip_selected = chip
	selected_chip_changed.emit(chip)

func is_chip_selected(chip)-> bool:
	return chip == chip_selected

func place_bet(new_position: Vector2):
	var chip_container = get_node("../Chip_Instance_Container")

	if chip_container != null:
		if chip_selected != null:
			var new_chip = chip_prefab.instantiate()
			new_chip.id = chip_selected.id
			new_chip.color = chip_selected.color
			new_chip.value = chip_selected.value
			new_chip.position = new_position
			new_chip.change_chip_size(chip_size)
			chip_container.add_child(new_chip)
