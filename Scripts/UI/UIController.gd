extends Node

#region UI Variables
# Exposed variables
@export var override_start_ui:bool = false
@export var canvases:Array[Control]
@export var video_player:VideoStreamPlayer
@export var label_game_states:Label

# Internal variables
var active : int = 0
#endregion

func _ready():
	if not override_start_ui:
		setup_initial_ui()
	else:
		active = get_active_canvas_index()
	
	toggle_play_video()
	
	_on_game_state_changed(active,GameManager.game_dictionary[active])
	GameManager.game_state_changed.connect(_on_game_state_changed)

#region UI Setup
func setup_initial_ui():
	for i in range(canvases.size()):
		if i == 0:
			canvases[i].show()
		else:
			canvases[i].hide()
	toggle_visibility(0)

func get_active_canvas_index() -> int:
	for i in range(canvases.size()):
		if canvases[i].is_visible_in_tree():
			return i
	return 0
#endregion

#region UI
func switch_active(state: int):
	if state == active:
		return
	
	canvases[active].hide()
	canvases[state].show()
	active = state
	toggle_play_video()
	_on_game_state_changed(active,GameManager.game_dictionary[active])

func toggle_play_video():
	if active == 0:
		video_player.play()
	else:
		video_player.stop()
#endregion

func toggle_visibility(state: int):
	switch_active(state)
	
	for canvas in canvases:
		if canvas.has_node("Environment_3D"):
			var environment_3d = canvas.get_node("Environment_3D")
			environment_3d.visible = (canvas == canvases[state])

func _on_game_state_changed(game_id, new_state):
	if not game_id == active:
		return
	
	label_game_states.text = "Juego: " + GameManager.get_game_name(game_id) + "\nEstado: " + GameManager.get_state_name(new_state)

func _on_button_exit_pressed():
	get_tree().quit()
