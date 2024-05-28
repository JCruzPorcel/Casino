extends Button

enum ButtonType {
	NUMBER,
	ZERO,
	DOUBLE_ZERO,
	_2_TO_1,
	_1ST_12,
	_2ND_12,
	_3RD_12,
	_1_TO_18,
	_19_TO_36,
	EVEN,
	ODD,
	COLOR_1,
	COLOR_2
}

enum ColorType {
	NONE,
	GENERIC,
	ZERO,
	COLOR_1,
	COLOR_2,
}

var button_type: ButtonType
var color_type: ColorType
var number_id: int
var betted_numbers: Array = []
var is_bet_placed:bool
var chip_instance:Control
var new_label_value:int

@onready var roulette_manager = get_node("/root/Scene_Main/=== UTILITIES ===/RouletteManager")
@onready var chip_controller = get_node("/root/Scene_Main/=== UI ===/UI_Canvas/=== GAMES ===/UI_Roulette/Chip_Container")
@onready var token_manager = get_node("/root/Scene_Main/=== UTILITIES ===/TokenManager")

func set_button_type(new_button_type: ButtonType, new_color: ColorType):
	button_type = new_button_type
	color_type = new_color

func set_betted_numbers(numbers: Array):
	betted_numbers = numbers
	if betted_numbers.size() > 0:
		var sorted_numbers = betted_numbers.duplicate()
		sorted_numbers.sort()
		betted_numbers = sorted_numbers

func set_number_id(new_number_id: int):
	number_id = new_number_id

func set_text_label(new_text: String):
	var label = get_node("Label")
	label.text = new_text

func set_rect_color(new_color: Color):
	var color_rect = get_node("ColorRect")
	color_rect.color = new_color

func _on_pressed():
	instantiate_new_chip()

func get_new_color() -> Color:
	var colors = chip_controller.get_value_color_mapping()

	# Calcular el índice basado en la división entera del nuevo valor entre 1000 (si es que se desea que sea cada ese valor)
	@warning_ignore("integer_division")
	var index = int(new_label_value / 1000) - 1  # Restamos 1 para obtener un índice de 0 a n-1

	# Asegurarnos de que el índice no sea menor que 0
	if index < 0:
		index = 0

	# Asegurarnos de que el índice no sea mayor que el tamaño de la matriz de colores
	if index >= colors.size():
		index = colors.size() - 1

	return colors[index]

func get_color_type_as_text(color: ColorType) -> String:
	match color:
		ColorType.NONE:
			return "NONE"
		ColorType.GENERIC:
			return "GENERIC"
		ColorType.ZERO:
			return "ZERO"
		ColorType.COLOR_1:
			return "COLOR_1"
		ColorType.COLOR_2:
			return "COLOR_2"
		_:
			return "UNKNOWN"

func instantiate_new_chip():
	if !can_instantiate_chip():
		return

	var chip_instance_container = get_tree().root.get_node("Scene_Main/=== UI ===/UI_Canvas/=== GAMES ===/UI_Roulette/Chip_Instance_Container")
	if chip_instance_container == null:
		return

	var selected_chip = chip_controller.get_selected_chip()
	if selected_chip == null:
		return

	if !token_manager.can_bet(selected_chip.value):
		return

	if !is_bet_placed:
		instantiate_chip(selected_chip, chip_instance_container)
		is_bet_placed = true

	update_label_and_bet_numbers(selected_chip)

	if new_label_value >= 10000:
		chip_instance.change_chip_color(get_new_color())

	roulette_manager.betting_phase()

func can_instantiate_chip() -> bool:
	return GameManager.is_current_state(GameManager.GameID.Roulette, GameManager.GameStates.Betting) || GameManager.is_current_state(GameManager.GameID.Roulette, GameManager.GameStates.Idle)

func instantiate_chip(selected_chip, chip_instance_container):
	var new_position = Rect2(global_position, size).position + size / 2 # Button Center Position
	var chip_prefab = chip_controller.get_chip_prefab()
	var chip_size = chip_controller.get_chip_size()
	var new_chip = chip_prefab.instantiate()
	new_chip.id = selected_chip.id
	new_chip.color = selected_chip.color
	new_chip.value = selected_chip.value
	new_chip.position = new_position
	new_chip.change_chip_size(chip_size)
	chip_instance_container.add_child(new_chip)
	chip_instance = new_chip

func update_label_and_bet_numbers(selected_chip):
	new_label_value = new_label_value + selected_chip.value
	var chip_label = chip_instance.get_label()
	chip_label.text = str(new_label_value)
	roulette_manager.set_betted_numbers(betted_numbers, selected_chip.value)
