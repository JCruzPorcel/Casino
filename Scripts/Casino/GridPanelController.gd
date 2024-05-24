extends Control

# Variables
#region Variables
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

const numbers_1_to_18: Array[int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18]
const numbers_19_to_36: Array[int] = [19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36]
#endregion
#region Button path's
@onready var top_row = $Numbers/Grid_Numbers/Top_Row.get_children()
@onready var mid_row = $Numbers/Grid_Numbers/Mid_Row.get_children()
@onready var bot_row = $Numbers/Grid_Numbers/Bot_Row.get_children()

@onready var top_row_horizontal = $Numbers/Grid_Horizontal/Top_Row.get_children()
@onready var mid_row_horizontal = $Numbers/Grid_Horizontal/Mid_Row.get_children()
@onready var bot_row_horizontal = $Numbers/Grid_Horizontal/Bot_Row.get_children()

@onready var top_row_center = $Numbers/Grid_Center/Top_Row.get_children()
@onready var bot_row_center = $Numbers/Grid_Center/Bot_Row.get_children()

@onready var top_row_vertical = $Numbers/Grid_Vertical/Top_Row.get_children()
@onready var bot_row_vertical = $Numbers/Grid_Vertical/Bot_Row.get_children()
#endregion
var number_colors = {} 
#endregion

func _ready():
	set_button_colors()
	set_zero_buttons()
	set_special_buttons()
	assign_adjacents_numbers()

# Setup Buttons
#region Button Setup Functions

func set_zero_buttons():
	var zero_button = $Zero_Double_Zero/GridContainer/P_Button_0

	zero_button.set_button_type(zero_button.ButtonType.ZERO, zero_button.ColorType.ZERO)
	zero_button.set_number_id(0)
	zero_button.set_text_label("0")
	zero_button.set_rect_color(zero_color)
	zero_button.set_betted_numbers([0])

	var double_zero_button = $Zero_Double_Zero/GridContainer/P_Button_00

	double_zero_button.visible = enable_double_zero

	double_zero_button.set_button_type(double_zero_button.ButtonType.DOUBLE_ZERO, double_zero_button.ColorType.ZERO)
	double_zero_button.set_number_id(00)
	double_zero_button.set_text_label("00")
	double_zero_button.set_rect_color(zero_color)
	double_zero_button.set_betted_numbers([37]) # 37 = 00

func set_special_buttons():
#region Color buttons
	var button_color_1 = $ST_12/Bot/Color_Red_Black/P_Button_Color_1
	var button_color_2 = $ST_12/Bot/Color_Red_Black/P_Button_Color_2

	button_color_1.set_button_type(button_color_1.ButtonType.COLOR_1, button_color_1.ColorType.COLOR_1)
	button_color_1.set_text_label(color_name_1)
	button_color_1.set_rect_color(color_option_1)
	button_color_1.set_betted_numbers(get_color_1_numbers())

	button_color_2.set_button_type(button_color_2.ButtonType.COLOR_2, button_color_2.ColorType.COLOR_2)
	button_color_2.set_text_label(color_name_2)
	button_color_2.set_rect_color(color_option_2)
	button_color_2.set_betted_numbers(get_color_2_numbers())
#endregion

#region Number labels with font size adjustment
	var labels_to_resize = [
		$ST_12/Bot/_1_To_18_Even/P_Button_1To18,
		$ST_12/Bot/_1_To_18_Even/P_Button_Even,
		$ST_12/Bot/Odd_19_To_36/P_Button_Odd,
		$ST_12/Bot/Odd_19_To_36/P_Button_19To36,
		$"2_To_1/GridContainer/P_Button_Number",
		$"2_To_1/GridContainer/P_Button_Number2",
		$"2_To_1/GridContainer/P_Button_Number3",
		$"ST_12/Bot/Color_Red_Black/P_Button_Color_1",
		$"ST_12/Bot/Color_Red_Black/P_Button_Color_2"
	]

	for button in labels_to_resize:
		var label = button.get_node("Label")
		label.add_theme_font_size_override("font_size", 30)
#endregion

#region Assign generic color to other buttons
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
		button.set_rect_color(generic_color)

#endregion

#region 1 to 18 & 19 to 36
	var button_1_to_18 = $ST_12/Bot/_1_To_18_Even/P_Button_1To18
	button_1_to_18.set_text_label(_1_to_18)
	button_1_to_18.set_betted_numbers(numbers_1_to_18)
	button_1_to_18.set_button_type(button_1_to_18.ButtonType._1_TO_18, button_1_to_18.ColorType.GENERIC)

	var button_19_to_36 = $ST_12/Bot/Odd_19_To_36/P_Button_19To36
	button_19_to_36.set_text_label(_19_to_36)
	button_19_to_36.set_betted_numbers(numbers_19_to_36)
	button_19_to_36.set_button_type(button_19_to_36.ButtonType._19_TO_36, button_1_to_18.ColorType.GENERIC)

#endregion

#region even & odd
	var button_even = $ST_12/Bot/_1_To_18_Even/P_Button_Even
	button_even.set_text_label(even)
	button_even.set_betted_numbers(get_even_numbers())
	button_even.set_button_type(button_even.ButtonType.EVEN, button_even.ColorType.GENERIC)

	var button_odd = $ST_12/Bot/Odd_19_To_36/P_Button_Odd
	button_odd.set_text_label(odd)
	button_odd.set_betted_numbers(get_odd_numbers())
	button_odd.set_button_type(button_odd.ButtonType.ODD, button_odd.ColorType.GENERIC)

#endregion

#region 2 to 1 buttons
	var button_2_to_1_1 = $"2_To_1/GridContainer/P_Button_Number"
	var button_2_to_1_2 = $"2_To_1/GridContainer/P_Button_Number2"
	var button_2_to_1_3 = $"2_To_1/GridContainer/P_Button_Number3"

	button_2_to_1_1.set_text_label(_2_to_1)
	button_2_to_1_2.set_text_label(_2_to_1)
	button_2_to_1_3.set_text_label(_2_to_1)

	button_2_to_1_1.set_betted_numbers(top_row_numbers)
	button_2_to_1_2.set_betted_numbers(mid_row_numbers)
	button_2_to_1_3.set_betted_numbers(bot_row_numbers)

	button_2_to_1_1.set_button_type(button_2_to_1_1.ButtonType._2_TO_1, button_2_to_1_1.ColorType.GENERIC)
	button_2_to_1_2.set_button_type(button_2_to_1_2.ButtonType._2_TO_1, button_2_to_1_2.ColorType.GENERIC)
	button_2_to_1_3.set_button_type(button_2_to_1_3.ButtonType._2_TO_1, button_2_to_1_3.ColorType.GENERIC)

	#endregion 

#region ST 12 buttons
	var button_st_12_1 = $ST_12/Bot/P_Button_1ST12
	var button_st_12_2 = $ST_12/Bot/P_Button_2ND12
	var button_st_12_3 = $ST_12/Bot/P_Button_3RD12

	button_st_12_1.set_text_label(st_12[0])
	button_st_12_2.set_text_label(st_12[1])
	button_st_12_3.set_text_label(st_12[2])

	button_st_12_1.set_betted_numbers(get_dozen_numbers(1)) # Primera Docena
	button_st_12_2.set_betted_numbers(get_dozen_numbers(2)) # Segunda Docena
	button_st_12_3.set_betted_numbers(get_dozen_numbers(3)) # Tercera Docena

	button_st_12_1.set_button_type(button_st_12_1.ButtonType._1ST_12, button_st_12_1.ColorType.GENERIC)
	button_st_12_2.set_button_type(button_st_12_2.ButtonType._2ND_12, button_st_12_2.ColorType.GENERIC)
	button_st_12_3.set_button_type(button_st_12_3.ButtonType._3RD_12, button_st_12_3.ColorType.GENERIC)
#endregion

#region Button Color Configuration
func set_button_colors():
	set_row_colors(bot_row, true, bot_row_numbers)
	set_row_colors(mid_row, false, mid_row_numbers)
	set_row_colors(top_row, true, top_row_numbers)

func set_row_colors(row_buttons, start_with_color1: bool, numbers: Array[int]):
	var use_color1 = start_with_color1

	for i in range(row_buttons.size()):
		var button = row_buttons[i]
		var color = Color()
		if use_color1:
			color = color_option_1
			button.set_rect_color(color_option_1)
			button.set_button_type(button.ButtonType.NUMBER, button.ColorType.COLOR_1)
		else:
			color = color_option_2
			button.set_rect_color(color_option_2)
			button.set_button_type(button.ButtonType.NUMBER, button.ColorType.COLOR_2)

		use_color1 = !use_color1

		button.set_text_label(str(numbers[i]))
		button.set_number_id(numbers[i])
		button.set_betted_numbers([numbers[i]])

		number_colors[numbers[i]] = color
#endregion
#endregion

# Number Categorization
#region Number Categorization
func get_dozen_numbers(dozen_number: int) -> Array[int]:
	if dozen_number < 1 or dozen_number > 3:
		print("Número de docena inválido. Debe ser 1, 2 o 3.")
		return []
	
	var dozen_start = (dozen_number - 1) * 12 + 1
	var dozen_end = dozen_number * 12
	var dozen_numbers: Array[int] = []

	for number in top_row_numbers:
		if number >= dozen_start and number <= dozen_end:
			dozen_numbers.append(number)
	for number in mid_row_numbers:
		if number >= dozen_start and number <= dozen_end:
			dozen_numbers.append(number)
	for number in bot_row_numbers:
		if number >= dozen_start and number <= dozen_end:
			dozen_numbers.append(number)

	return dozen_numbers

func get_even_numbers() -> Array[int]:
	var even_numbers: Array[int] = []

	for number in top_row_numbers:
		if number % 2 == 0:
			even_numbers.append(number)
	for number in mid_row_numbers:
		if number % 2 == 0:
			even_numbers.append(number)
	for number in bot_row_numbers:
		if number % 2 == 0:
			even_numbers.append(number)

	return even_numbers

func get_odd_numbers() -> Array[int]:
	var odd_numbers: Array[int] = []

	for number in top_row_numbers:
		if number % 2 != 0:
			odd_numbers.append(number)
	for number in mid_row_numbers:
		if number % 2 != 0:
			odd_numbers.append(number)
	for number in bot_row_numbers:
		if number % 2 != 0:
			odd_numbers.append(number)

	return odd_numbers

func get_color_1_numbers() -> Array[int]:
	var red_numbers: Array[int] = []

	for number in number_colors.keys():
		if number_colors[number] == color_option_1:  # Suponiendo que color_option_1 es rojo
			red_numbers.append(number)

	return red_numbers

func get_color_2_numbers() -> Array[int]:
	var black_numbers: Array[int] = []

	for number in number_colors.keys():
		if number_colors[number] == color_option_2:  # Suponiendo que color_option_2 es negro
			black_numbers.append(number)

	return black_numbers

func assign_vertical_adjacent_numbers(vertical_buttons: Array, top_row_buttons: Array, mid_row_buttons: Array, bot_row_buttons: Array):
	for i in range(top_row_buttons.size()):
		var top_number = top_row_buttons[i].betted_numbers[0]
		var mid_number = mid_row_buttons[i].betted_numbers[0]

		vertical_buttons[0][i].set_betted_numbers([top_number, mid_number])

	for i in range(mid_row_buttons.size()):
		var mid_number = mid_row_buttons[i].betted_numbers[0]
		var bot_number = bot_row_buttons[i].betted_numbers[0]

		vertical_buttons[1][i].set_betted_numbers([mid_number, bot_number])

func assign_horizontal_adjacent_numbers(horizontal_buttons: Array, buttons_number: Array):
	for i in range(1, horizontal_buttons.size()):
		var left_number = buttons_number[i - 1].betted_numbers[0]
		var right_number = buttons_number[i].betted_numbers[0]
		horizontal_buttons[i - 1].set_betted_numbers([left_number, right_number])
		horizontal_buttons[i].set_betted_numbers([left_number, right_number])
#endregion

func assign_adjacents_numbers():
	var horizontal_buttons = [
		[top_row, top_row_horizontal],
		[mid_row, mid_row_horizontal],
		[bot_row, bot_row_horizontal]
	]

	for button_pair in horizontal_buttons:
		assign_horizontal_adjacent_numbers(button_pair[1], button_pair[0])

	var vertical_buttons = [
	top_row_vertical,
	bot_row_vertical
	]
	assign_vertical_adjacent_numbers(vertical_buttons, top_row, mid_row, bot_row)
