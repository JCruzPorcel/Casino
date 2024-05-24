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

@onready var chip_controller = get_node("/root/Scene_Main/=== UI ===/UI_Canvas/=== GAMES ===/UI_Roulette/HBoxContainer")

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
	var button_size = size
	var button_center = Rect2(global_position, button_size).position + button_size / 2
	chip_controller.place_bet(button_center)
	print(betted_numbers)
	print(get_color_type_as_text(color_type))

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
