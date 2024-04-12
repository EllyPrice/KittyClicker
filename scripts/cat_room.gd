extends HBoxContainer

@onready var payout_timer: Timer = %PayoutTimer

func _on_cat_container_pressed(cat: Cat) -> void:
	set_cat_vars(cat)
	add_child(cat)

func set_cat_vars(cat: Cat) -> void:
	cat.position.x = 0
	cat.position.y = randi_range(96, 480)
