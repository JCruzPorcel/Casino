extends Control

# Exported variables
#region Color Settings
@export_subgroup("Color Grid")
@export_color_no_alpha var color_option_1: Color
@export_color_no_alpha var color_option_2: Color

@export_subgroup("Color Background & Buttons")
@export_color_no_alpha var background_color: Color
@export_color_no_alpha var generic_color: Color

@export_subgroup("Zero Settings")
@export_color_no_alpha var zero_color: Color
@export var enable_double_zero: bool = false

@export_subgroup("Name Buttons")
@export var _2_to_1: String
@export var st_12: Array[String]
@export var _1_to_18: String
@export var even: String
@export var odd: String
@export var _19_to_36: String
@export var color_name_1: String
@export var color_name_2: String
#endregion

# Constants
#region Number Constants
const top_row_numbers: Array[int] = [3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36]
const mid_row_numbers: Array[int] = [2, 5, 8, 11, 14, 17, 20, 23, 26, 29, 32, 35]
const bot_row_numbers: Array[int] = [1, 4, 7, 10, 13, 16, 19, 22, 25, 28, 31, 34]
#endregion

func _ready():
	set_button_colors()
	set_zero_buttons()
	set_special_buttons()

# Setup Buttons
#region Button Setup Functions
func set_zero_buttons():
	var double_zero_button = $Zero_Double_Zero/GridContainer/P_Button_00
	var double_zero_color_rect = double_zero_button.get_node("ColorRect")
	var double_zero_label = double_zero_button.get_node("Label")

	double_zero_button.visible = enable_double_zero
	double_zero_color_rect.color = zero_color
	double_zero_label.text = "00"

	var zero_button = $Zero_Double_Zero/GridContainer/P_Button_0
	var zero_color_rect = zero_button.get_node("ColorRect")
	var zero_label = zero_button.get_node("Label")

	zero_color_rect.color = zero_color
	zero_label.text = "0"

func set_special_buttons():
	# Color buttons
	var button_color_1 = $ST_12/Bot/Color_Red_Black/P_Button_Red.get_node("ColorRect")
	var button_color_2 = $ST_12/Bot/Color_Red_Black/P_Button_Black.get_node("ColorRect")

	button_color_1.color = color_option_1
	button_color_2.color = color_option_2

	# Assign color names to labels
	var label_color_1 = button_color_1.get_parent().get_node("Label")
	var label_color_2 = button_color_2.get_parent().get_node("Label")
	label_color_1.text = color_name_1
	label_color_2.text = color_name_2

	# Number labels with font size adjustment
	var labels_to_resize = [
		$ST_12/Bot/_1_To_18_Even/P_Button_1To18,
		$ST_12/Bot/_1_To_18_Even/P_Button_Even,
		$ST_12/Bot/Odd_19_To_36/P_Button_Odd,
		$ST_12/Bot/Odd_19_To_36/P_Button_19To36,
		$"2_To_1/GridContainer/P_Button_Number",
		$"2_To_1/GridContainer/P_Button_Number2",
		$"2_To_1/GridContainer/P_Button_Number3",
		$"ST_12/Bot/Color_Red_Black/P_Button_Red",
		$"ST_12/Bot/Color_Red_Black/P_Button_Black"
	]

	for button in labels_to_resize:
		var label = button.get_node("Label")
		label.add_theme_font_size_override("font_size", 30)

	# Assign generic color to other buttons
	var generic_buttons = [
		$ST_12/Bot/_1_To_18_Even/P_Button_1To18,
		$ST_12/Bot/_1_To_18_Even/P_Button_Even,
		$ST_12/Bot/Odd_19_To_36/P_Button_Odd,
		$ST_12/Bot/Odd_19_To_36/P_Button_19To36,
		$"2_To_1/GridContainer/P_Button_Number",
		$"2_To_1/GridContainer/P_Button_Number2",
		$"2_To_1/GridContainer/P_Button_Number3",
		$ST_12/Bot/P_Button_1ST12,
		$ST_12/Bot/P_Button_2ND12,
		$ST_12/Bot/P_Button_3RD12
	]

	for button in generic_buttons:
		var button_color_rect = button.get_node("ColorRect")
		button_color_rect.color = generic_color

	var button_1_to_18 = $ST_12/Bot/_1_To_18_Even/P_Button_1To18
	button_1_to_18.get_node("Label").text = _1_to_18

	var button_even = $ST_12/Bot/_1_To_18_Even/P_Button_Even
	button_even.get_node("Label").text = even

	var button_odd = $ST_12/Bot/Odd_19_To_36/P_Button_Odd
	button_odd.get_node("Label").text = odd

	var button_19_to_36 = $ST_12/Bot/Odd_19_To_36/P_Button_19To36
	button_19_to_36.get_node("Label").text = _19_to_36

	# 2 to 1 buttons
	var button_2_to_1_1 = $"2_To_1/GridContainer/P_Button_Number"
	var button_2_to_1_2 = $"2_To_1/GridContainer/P_Button_Number2"
	var button_2_to_1_3 = $"2_To_1/GridContainer/P_Button_Number3"

	button_2_to_1_1.get_node("Label").text = _2_to_1
	button_2_to_1_2.get_node("Label").text = _2_to_1
	button_2_to_1_3.get_node("Label").text = _2_to_1

	# ST_12 buttons
	var button_st_12_1 = $ST_12/Bot/P_Button_1ST12
	var button_st_12_2 = $ST_12/Bot/P_Button_2ND12
	var button_st_12_3 = $ST_12/Bot/P_Button_3RD12

	button_st_12_1.get_node("Label").text = st_12[0]
	button_st_12_2.get_node("Label").text = st_12[1]
	button_st_12_3.get_node("Label").text = st_12[2]

func set_button_colors():
	var bot_row = $Numbers/Grid_Numbers/Bot_Row.get_children()
	var mid_row = $Numbers/Grid_Numbers/Mid_Row.get_children()
	var top_row = $Numbers/Grid_Numbers/Top_Row.get_children()

	set_row_colors(bot_row, true, bot_row_numbers)
	set_row_colors(mid_row, false, mid_row_numbers)
	set_row_colors(top_row, true, top_row_numbers)

func set_row_colors(row_buttons, start_with_color1: bool, numbers: Array[int]):
	var use_color1 = start_with_color1

	for i in range(row_buttons.size()):
		var button = row_buttons[i]
		var color_rect = button.get_node("ColorRect")
		if use_color1:
			color_rect.color = color_option_1
		else:
			color_rect.color = color_option_2
		use_color1 = !use_color1

		var button_label = button.get_node("Label")
		button_label.text = str(numbers[i])
#endregion
