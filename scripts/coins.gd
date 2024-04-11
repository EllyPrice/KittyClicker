extends Node

var amount: float = 1000000000

func deposit(payout: float) -> void:
	amount += payout

func withdraw(cost: float) -> void:
	amount -= cost
