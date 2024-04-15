extends Sprite2D
class_name Lure

var is_in_hand: bool
var kill_timer_started: bool
var cost: float
@onready var kill_timer: Timer = $KillTimer

func _process(_delta: float) -> void:
	if Input.is_action_just_released("left_click"):
		if global_position.x > 400 or global_position.y > 512 or global_position.x < 64 or global_position.y < 64:
			queue_free()
			return
		if is_in_hand:
			get_tree().call_group("lure_sellers", "lure_found_cat", get_instance_id())
			Coins.withdraw(cost)
			is_in_hand = false
	if is_in_hand:
		global_position = get_global_mouse_position()


func _on_kill_timer_timeout() -> void:
	queue_free()


func _on_update_timer_timeout() -> void:
	if !is_in_hand:
		get_tree().call_group("cats", "lure", global_position)
		if !kill_timer_started:
			for pos: Vector2 in CatData.cat_positions:
				if global_position.distance_squared_to(pos) < 1024:
					kill_timer.start()
					kill_timer_started = true
