extends Sprite2D
class_name Hat

var is_in_hand: bool
#var hat_scene: PackedScene = preload("res://scenes/meowboy_hat.tscn")
var cost: float
var emote_library_name: StringName

func _process(_delta: float) -> void:
	if is_in_hand:
		global_position = get_global_mouse_position()
	if Input.is_action_just_released("left_click"):
		if global_position.x > 400:
			queue_free()
			return
		for cat: Cat in CatData.cats:
			if cat.global_position.distance_squared_to(global_position) < 1024:
				if !cat.is_cowboy:
					if is_in_hand:
						get_tree().call_group("hat_sellers", "hat_found_cat", get_instance_id())
						Coins.withdraw(cost)
						is_in_hand = false
						cat.add_hat(self)

func get_emote_library() -> Array[String]:
	return Emotes.get_emote_library(emote_library_name)
