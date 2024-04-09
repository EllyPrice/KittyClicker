extends Control

@onready var cats_per_room_slider: HSlider = %CatsPerRoomSlider
@onready var min_cats: Label = %MinCats
@onready var current_cats: Label = %CurrentCats
@onready var max_cats: Label = %MaxCats


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	min_cats.text = str(cats_per_room_slider.min_value)
	max_cats.text = str(cats_per_room_slider.max_value)

func update_cats_per_room_setting(value: float) -> void:
	current_cats.text = str(value)
	Settings.max_cats_per_room = int(value)

func _on_cats_per_room_slider_value_changed(value: float) -> void:
	update_cats_per_room_setting(value)
