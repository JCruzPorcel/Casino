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

func set_button_type(new_button_type: ButtonType, new_color: ColorType):
	button_type = new_button_type
	color_tag = new_color
	print("Button type set")

func set_number_id(new_number_id: int):
	number_id = new_number_id
	print("Number ID set")

func set_text_label(new_text: String):
	var label = get_node("Label")
	label.text = new_text

func set_rect_color(new_color: Color):
	var color_rect = get_node("ColorRect")
	color_rect.color = new_color
