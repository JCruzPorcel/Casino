extends Node

@export var countdowns: Array[float] = [10.5, 1, 1.5, 5.5]
@export var ui_cd_timer: Control
@export var winning_number_label:Label

var current_timer: float = 0
var countdown_timer: float = 10.5  
var counting: bool = false
var phase_count: int = 0
var game_id = GameManager.GameID.Roulette
var betted_color
var betted_numbers_tokens: Dictionary = {}
 
@onready var grid_panel_controller = get_node("../../=== UI ===/UI_Canvas/=== GAMES ===/UI_Roulette/P_Roulette_GridPanels")
@onready var number_colors = grid_panel_controller.number_colors

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
					print("Fase no válida")
			
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
	GameManager.set_current_game_state(game_id, GameManager.GameStates.Idle)
	counting = false
	winning_number_label.text = ''
	betted_numbers_tokens.clear()
	clear_children("../../=== UI ===/UI_Canvas/=== GAMES ===/UI_Roulette/Chip_Instance_Container")

func betting_phase():
	GameManager.set_current_game_state(game_id, GameManager.GameStates.Betting)

func spinning_phase():
	GameManager.set_current_game_state(game_id, GameManager.GameStates.Spinning)

func stopped_phase():
	GameManager.set_current_game_state(game_id, GameManager.GameStates.Stopped)

func showing_results_phase():
	GameManager.set_current_game_state(game_id, GameManager.GameStates.ShowingResults)
	var win_number = random_number()
	check_winning_number(win_number)
	winning_number_label.text = "Winning Number: " + str(win_number) + "\nColor: " + get_winning_color(win_number)
#endregion

func ChangeCount(_gameID, _gameState):
	if(!GameManager.is_current_state(game_id, GameManager.GameStates.Betting)):
		return
	
	if counting:
		return
	counting = true

func random_number()->int:
	var number_rng:int = randi_range(0,37)
	return number_rng

func set_betted_numbers(numbers: Array, tokens: int, color: String):
	for i in range(numbers.size()):
		var number = numbers[i]
		
		if typeof(number) == TYPE_INT:
			# Si el número ya está en el diccionario, sumamos los nuevos tokens a los existentes
			if betted_numbers_tokens.has(number):
				betted_numbers_tokens[number]["tokens"] += tokens
			# Si el número no está en el diccionario, lo añadimos con los tokens nuevos
			else:
				betted_numbers_tokens[number] = {"tokens": tokens, "color": color}

	var sorted_keys = betted_numbers_tokens.keys()
	sorted_keys.sort()

	clear_console() #  DEBUG
	for key in sorted_keys:
		print("\nNúmero: #", key, " Apuesta: $", betted_numbers_tokens[key]["tokens"], " Color: ", betted_numbers_tokens[key]["color"])

func clear_console():
	# Imprimir 50 líneas en blanco para "limpiar" la consola
	for i in range(50):
		print(" ")

func clear_children(node_path: NodePath):
	var node_to_clear = get_node(node_path)
	if node_to_clear != null:
		for child in node_to_clear.get_children():
			node_to_clear.remove_child(child)

func check_winning_number(winning_number: int):
	if betted_numbers_tokens.has(winning_number):
		print("¡Número ganador encontrado! Número:", winning_number, "Tokens apostados:", betted_numbers_tokens[winning_number]["tokens"], "Color:", betted_numbers_tokens[winning_number]["color"])
	else:
		print("El número ganador no está entre los números apostados.")

func get_winning_color(winning_number: int) -> String:
	var grid_controller = get_node("../../=== UI ===/UI_Canvas/=== GAMES ===/UI_Roulette/P_Roulette_GridPanels")
	var color_1_numbers = grid_controller.get_color_1_numbers()
	var color_2_numbers = grid_controller.get_color_2_numbers()

	if color_1_numbers.has(winning_number):
		return grid_controller.color_name_1
	elif color_2_numbers.has(winning_number):
		return grid_controller.color_name_2
	else:
		return "Unknown"

