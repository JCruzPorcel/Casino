extends Node

var timer: float = 0
var counting: bool = false
var phase_count: int = 0
var game_id = GameManager.GameID.Roulette
@export var ui_cd_timer: Control
@export var winning_number_label:Label

func _ready():
	counting = false
	set_cd_timer_visibility()
	GameManager.game_state_changed.connect(ChangeCount)
	winning_number_label.text = ''

func _process(delta):
	if counting:
		timer += delta
		
		# Contador de 10.5 segundos (para que muestre el número 10 y espere para cambiar de estado)
		if timer >= 10.5:
			timer = 0
			
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
			texture_progress_bar.value = timer / 10.0 * 100.0
		if label is Label:
			# Limita el valor del temporizador dentro del rango [0, 100]
			timer = clamp(timer, 0, 100)
			# Convierte el temporizador a entero y luego a cadena de texto
			label.text = str(int(timer))

func set_cd_timer_visibility():
	if ui_cd_timer is Control:
		if counting:
			ui_cd_timer.show()
		else:
			ui_cd_timer.hide()
#endregion

#region Funciones para cada fase de la ruleta
func idle_phase():
	GameManager.set_current_game_state(game_id, GameManager.GameStates.Idle)
	counting = false
	winning_number_label.text = ''

func betting_phase():
	GameManager.set_current_game_state(game_id, GameManager.GameStates.Betting)

func spinning_phase():
	GameManager.set_current_game_state(game_id, GameManager.GameStates.Spinning)

func stopped_phase():
	GameManager.set_current_game_state(game_id, GameManager.GameStates.Stopped)

func showing_results_phase():
	GameManager.set_current_game_state(game_id, GameManager.GameStates.ShowingResults)
	winning_number_label.text = "Winning Number: " + str(random_number())
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

func number_color():
	# TODO: Pasar color del numero ganador
	pass
