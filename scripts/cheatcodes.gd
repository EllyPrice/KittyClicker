extends Control

@onready var money_exploit_label: Label = %MoneyExploitLabel
@onready var money_exploit_field: LineEdit = %MoneyExploitField
@onready var enter_cheatcode_field: LineEdit = %EnterCheatcodeField

func _on_money_exploit_field_text_submitted(new_text: String) -> void:
	if new_text.to_float() != null:
		Coins.amount += new_text.to_float()
	money_exploit_field.clear()

func _on_enter_cheatcode_field_text_submitted(new_text: String) -> void:
	if new_text == "swag":
		money_exploit_field.show()
		money_exploit_label.show()
	enter_cheatcode_field.clear()
