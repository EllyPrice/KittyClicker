extends Node

var amount: float = 999999

func deposit(payout: float) -> void:
	amount += payout

func withdraw(cost: float) -> void:
	amount -= cost
