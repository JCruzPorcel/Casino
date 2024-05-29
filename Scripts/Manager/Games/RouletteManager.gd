extends Node

@export var countdowns: Array[float] = [10.5, 1, 1.5, 5.5]
@export var ui_cd_timer: Control
@export var winning_number_label: Label

var current_timer: float = 0
var countdown_timer: float = 10.5
var counting: bool = false
var phase_count: int = 0
var game_id = GameManager.GameID.Roulette

# Enum para los tipos de apuestas
enum BetType {
	STRAIGHT_UP,
	SPLIT,
	STREET,
	CORNER,
	SIX_LINE,
	COLUMN,
	DOZEN,
	EVEN_MONEY
}

# Diccionario para almacenar las apuestas, categorizadas por tipo
var betted_numbers_tokens: Dictionary = {
	BetType.STRAIGHT_UP: [],
	BetType.SPLIT: [],
	BetType.STREET: [],
	BetType.CORNER: [],
	BetType.SIX_LINE: [],
	BetType.COLUMN: [],
	BetType.DOZEN: [],
	BetType.EVEN_MONEY: []
}

@onready var grid_panel_controller = get_node("../../=== UI ===/UI_Canvas/=== GAMES ===/UI_Roulette/P_Roulette_GridPanels")
@onready var number_colors = grid_panel_controller.number_colors
@onready var enable_double_zero: bool = grid_panel_controller.enable_double_zero
@onready var pay_bet_controller = get_node("PayBetController")
@onready var token_manager = get_node("../TokenManager")

func _ready():
	counting = false
	set_cd_timer_visibility()
	GameManager.game_state_changed.connect(ChangeCount)
	winning_number_label.text = ''

func _process(delta):
	if counting:
		current_timer += delta

		if current_timer >= countdown_timer:
			current_timer = 0

			# Ejecutar la función correspondiente a la fase actual
			match phase_count:
				0:
					spinning_phase()
				1:
					stopped_phase()
				2:
					showing_results_phase()
				3:
					idle_phase()
				_:
					print_debug("Fase no válida")
			
			# Incrementar la fase
			phase_count += 1
			if phase_count >= 4:
				phase_count = 0

			countdown_timer = countdowns[phase_count]

	# Actualizar el progreso del TextureProgressBar y el Label
	update_timer_ui()
	set_cd_timer_visibility()

#region timer
func update_timer_ui():
	if ui_cd_timer is Control:
		var texture_progress_bar := ui_cd_timer.get_node("TextureProgressBar")
		var label := texture_progress_bar.get_node("Label")
		if texture_progress_bar is TextureProgressBar:
			# Normaliza el temporizador dentro del rango [0, 1]
			texture_progress_bar.value = current_timer / countdown_timer * 100
		if label is Label:
			# Limita el valor del temporizador dentro del rango [0, 100]
			current_timer = clamp(current_timer, 0, 100)
			# Convierte el temporizador a entero y luego a cadena de texto
			label.text = str(int(current_timer))

func set_cd_timer_visibility():
	if ui_cd_timer is Control:
		if counting:
			ui_cd_timer.show()
		else:
			ui_cd_timer.hide()
#endregion

#region Roulette Phase Functions
func idle_phase():
	winning_number_label.text = ''
	clear_bets()

func betting_phase():
	GameManager.set_current_game_state(game_id, GameManager.GameStates.Betting)

func spinning_phase():
	GameManager.set_current_game_state(game_id, GameManager.GameStates.Spinning)

func stopped_phase():
	GameManager.set_current_game_state(game_id, GameManager.GameStates.Stopped)

func showing_results_phase():
	GameManager.set_current_game_state(game_id, GameManager.GameStates.ShowingResults)
	var win_number = random_number()
	winning_number_label.text = "Winning Number: " + str(win_number) + "\nColor: " + get_winning_color(win_number)
	
	if check_winning_number(win_number):
		var total_payout: float = 0
		for bet_type in betted_numbers_tokens.keys():
			for bet in betted_numbers_tokens[bet_type]:
				total_payout += pay_out_bets(win_number, bet["tokens"], bet_type)
		print_debug("Total payout:", total_payout)
		token_manager.deposit_tokens(total_payout)
#endregion

func ChangeCount(_gameID, _gameState):
	if !GameManager.is_current_state(game_id, GameManager.GameStates.Betting):
		return
	
	if counting:
		return
	counting = true

func random_number() -> int:
	var number_rng: int
	
	if enable_double_zero:
		number_rng = randi_range(0, 37)
	else:
		number_rng = randi_range(0, 36)
	return number_rng

func set_betted_numbers(numbers: Array, tokens: int, bet_type: BetType):
	clear_console()
	
	if not betted_numbers_tokens.has(bet_type):
		print_debug("Tipo de apuesta no válido")
		return
	
	betted_numbers_tokens[bet_type].append({"numbers": numbers, "tokens": tokens})
	
	print("Apuestas realizadas:")
	for bet_type_key in betted_numbers_tokens.keys():
		for bet in betted_numbers_tokens[bet_type_key]:
			print("Tipo de apuesta:", bet_type_to_string(bet_type_key) + " Números:", bet["numbers"], "Tokens apostados:", bet["tokens"])

func bet_type_to_string(bet_type: BetType) -> String:
	match bet_type:
		BetType.STRAIGHT_UP:
			return "Straight Up"
		BetType.SPLIT:
			return "Split"
		BetType.STREET:
			return "Street"
		BetType.CORNER:
			return "Corner"
		BetType.SIX_LINE:
			return "Six Line"
		BetType.COLUMN:
			return "Column"
		BetType.DOZEN:
			return "Dozen"
		BetType.EVEN_MONEY:
			return "Even Money"
		_:
			return "Unknown"

func clear_console():
	# Imprimir 50 líneas en blanco para "limpiar" la consola
	for i in range(50):
		print(" ")

func clear_children(node_path: NodePath):
	var node_to_clear = get_node(node_path)
	if node_to_clear != null:
		for child in node_to_clear.get_children():
			node_to_clear.remove_child(child)

func check_winning_number(winning_number: int) -> bool:
	for bet_type in betted_numbers_tokens.keys():
		for bet in betted_numbers_tokens[bet_type]:
			if winning_number in bet["numbers"]:
				return true
	return false

func get_winning_color(winning_number: int) -> String:
	var grid_controller = get_node("../../=== UI ===/UI_Canvas/=== GAMES ===/UI_Roulette/P_Roulette_GridPanels")
	var color_1_numbers = grid_controller.get_color_1_numbers()
	var color_2_numbers = grid_controller.get_color_2_numbers()

	if color_1_numbers.has(winning_number):
		return grid_controller.color_name_1
	elif color_2_numbers.has(winning_number):
		return grid_controller.color_name_2
	else:
		return "GREEN"

func clear_bets():
	GameManager.set_current_game_state(game_id, GameManager.GameStates.Idle)
	counting = false
	phase_count = 0
	current_timer = 0
	betted_numbers_tokens = {
		BetType.STRAIGHT_UP: [],
		BetType.SPLIT: [],
		BetType.STREET: [],
		BetType.CORNER: [],
		BetType.SIX_LINE: [],
		BetType.COLUMN: [],
		BetType.DOZEN: [],
		BetType.EVEN_MONEY: []
	}
	clear_children("../../=== UI ===/UI_Canvas/=== GAMES ===/UI_Roulette/Chip_Instance_Container")

func clear_bets_button():
	if GameManager.is_current_state(game_id, GameManager.GameStates.Idle) or GameManager.is_current_state(game_id, GameManager.GameStates.Betting):
		clear_console()
		clear_bets()

func pay_out_bets(win_number: int, bet_amount: float, bet_type: BetType) -> float:
	var total_payout: float = 0
	
	for bet in betted_numbers_tokens[bet_type]:
		if win_number in bet["numbers"]:
			match bet_type:
				BetType.STRAIGHT_UP:
					total_payout += pay_bet_controller.pay_straight_up(bet_amount)
				BetType.SPLIT:
					total_payout += pay_bet_controller.pay_split(bet_amount)
				BetType.STREET:
					total_payout += pay_bet_controller.pay_street(bet_amount)
				BetType.CORNER:
					total_payout += pay_bet_controller.pay_corner(bet_amount)
				BetType.SIX_LINE:
					total_payout += pay_bet_controller.pay_six_line(bet_amount)
				BetType.COLUMN, BetType.DOZEN:
					total_payout += pay_bet_controller.pay_column_dozen(bet_amount)
				BetType.EVEN_MONEY:
					total_payout += pay_bet_controller.pay_even_money(bet_amount)
	
	return total_payout
	
