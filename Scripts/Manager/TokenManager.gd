extends Node

@export var tokens_label:Label
var current_tokens:float = 0

func _ready():
	update_tokens()

func _process(_delta):
	if Input.is_action_pressed("ui_up"):
		deposit_tokens(500)
	if Input.is_action_pressed("ui_down"):
		can_bet(500)

func deposit_tokens(amount:float):
	current_tokens += amount
	update_tokens()

func debit_tokens(amount:float):
	current_tokens -= amount
	update_tokens()

func can_bet(amount:float)-> bool:
	if(current_tokens >= amount):
		debit_tokens(amount)
	else:
		print_debug("Tokens insuficientes para efectuar la operación")
		return false
	
	return true

func update_tokens():
	tokens_label.text = "Tokens: " + str(current_tokens)
