extends HBoxContainer
 
@export var chip_prefab:PackedScene
var chip_selected
signal selected_chip_changed(new_chip)

func set_selected_chip(chip):
	if chip == chip_selected:
		return
	
	chip_selected = chip
	selected_chip_changed.emit(chip)

func is_chip_selected(chip)-> bool:
	return chip == chip_selected


func place_bet():
	pass
