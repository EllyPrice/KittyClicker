extends HBoxContainer


@onready var debug: Label = %Debug
@onready var payout_timer: Timer = %PayoutTimer

var num_cats: int = -1
var disabled_catids: Array[int]
var disabled_cat_pos: Array[Vector2]

func _on_cat_container_pressed(cat: Cat) -> void:
	set_cat_vars(cat)
	add_child(cat)

func set_cat_vars(cat: Cat) -> void:
	cat.position.x = 0
	cat.position.y = randi_range(96, 480)

func _set_debug_label_to(string: String) -> void:
	debug.text = string
