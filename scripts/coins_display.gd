extends Label

var last_text: String

func _ready() -> void:
	text = "%s catcoins" % Math.format_large_number(Coins.amount)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var new_text: String = "%s catcoins" % Math.format_large_number(Coins.amount)
	if new_text != last_text:
		text = "%s catcoins" % Math.format_large_number(Coins.amount)
		await GlobalHelpers._tree_timer(.1)
