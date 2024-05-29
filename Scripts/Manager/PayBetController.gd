extends Node

# Function to pay bets on a single number (Straight Up)
func pay_straight_up(bet: float) -> float:
	return bet * 35 + bet

# Function to pay bets on two numbers (Split)
func pay_split(bet: float) -> float:
	return bet * 17 + bet

# Function to pay bets on three numbers (Street)
func pay_street(bet: float) -> float:
	return bet * 11 + bet

# Function to pay bets on four numbers (Corner)
func pay_corner(bet: float) -> float:
	return bet * 8 + bet

# Function to pay bets on six numbers (Six Line)
func pay_six_line(bet: float) -> float:
	return bet * 5 + bet

# Function to pay bets on a column or dozen
func pay_column_dozen(bet: float) -> float:
	return bet * 2 + bet

# Function to pay bets on red/black, even/odd, or low/high
func pay_even_money(bet: float) -> float:
	return bet * 1 + bet
