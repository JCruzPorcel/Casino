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
	ZERO,
	COLOR_1,
	COLOR_2
}

var button_type: ButtonType
var color_tag: ColorType
var number_id: int
var _2_to_1_numbers: Array = []

@onready var chip_controller = get_node("/root/Scene_Main/=== UI ===/UI_Canvas/=== GAMES ===/UI_Roulette/HBoxContainer")

func set_button_type(new_button_type: ButtonType, new_color: ColorType):
	button_type = new_button_type
	color_tag = new_color
	
func set_2_to_1_numbers(numbers: Array):
	_2_to_1_numbers = numbers
	
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

