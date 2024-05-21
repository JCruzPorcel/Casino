extends Node

#region Enum para los estados del juego
enum GameStates {
	Idle,           # Estado inicial, esperando que comience el juego
	Betting,        # Fase de apuestas antes de comenzar el juego
	Dealing,        # Fase de reparto de cartas
	BettingRound,   # Fase de apuestas entre rondas (en juegos de cartas)
	Spinning,       # Fase de giro de la ruleta o sorteo de números
	Drawing,        # Fase de dibujo de números en el bingo
	PlayerTurn,     # Turno del jugador para tomar decisiones (en juegos de cartas)
	DealerTurn,     # Turno del crupier/dealer (en juegos de cartas)
	Checking,       # Fase de comprobación de resultados
	Stopped,        # Estado en el que el juego ha terminado pero no se han mostrado los resultados finales
	ShowingResults  # Fase de mostrar los resultados finales del juego
}

# Nombres correspondientes a los estados del juego
var game_state_names = {
	GameStates.Idle: "Idle",
	GameStates.Betting: "Betting",
	GameStates.Dealing: "Dealing",
	GameStates.BettingRound: "BettingRound",
	GameStates.Spinning: "Spinning",
	GameStates.Drawing: "Drawing",
	GameStates.PlayerTurn: "PlayerTurn",
	GameStates.DealerTurn: "DealerTurn",
	GameStates.Checking: "Checking",
	GameStates.Stopped: "Stopped",
	GameStates.ShowingResults: "ShowingResults"
}
#endregion

#region Nombres correspondientes a los juegos
var game_names = {
	GameID.None: "None",
	GameID.Roulette: "Roulette",
	GameID.Bingo: "Bingo",
	GameID.Poker: "Poker",
}

enum GameID{
	None,
	Roulette,
	Bingo,
	Poker
}
#endregion
var game_dictionary : Dictionary = {}

signal game_state_changed(game: GameID, new_state: GameStates)

func _ready():
	for game_id in GameID.values():
		game_dictionary[game_id] = GameStates.Idle
		get_game_and_state(game_id)

	set_current_game_state(GameID.None, GameStates.Idle)

#region Set
func set_current_game_state(game_id: GameID, new_state: GameStates):
	if game_dictionary[game_id] == new_state:
		return
	
	game_dictionary[game_id] = new_state
	game_state_changed.emit(game_id, new_state)
#endregion

func is_current_state(game_id:GameID, desired_state:GameStates) -> bool:
	return game_dictionary[game_id] == desired_state

#region Debug
func get_state_name(state: GameStates) -> String:
	return game_state_names[state]

func get_game_name(state: GameID) -> String:
	return game_names[state]

func get_game_and_state(game_id):
	var game_state = game_dictionary[game_id]
	return "Juego: " + get_game_name(game_id) + "\nEstado: " + get_state_name(game_state)
#endregion
