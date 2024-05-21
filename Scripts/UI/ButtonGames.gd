extends Control

const game_id_enum = preload("res://Scripts/GameManager.gd")

@export var ui_controller:CanvasLayer

@export var game_id: game_id_enum.GameID
@export var icon_image: Texture
var texture_rect: TextureRect
var game_id_value: int

func _ready():
	game_id_value = game_id
	texture_rect = get_child(0)
	texture_rect.texture = icon_image


func _on_pressed():
	ui_controller.toggle_visibility(game_id_value)
