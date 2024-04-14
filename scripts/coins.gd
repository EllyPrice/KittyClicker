extends Node

var amount: float = 0

func deposit(payout: float) -> void:
	amount += payout

func withdraw(cost: float) -> void:
	amount -= cost
