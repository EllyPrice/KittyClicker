extends AnimatedSprite2D
class_name BigCatcoin

var payout: float

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	pick_random_sound()
	audio_stream_player_2d.play()
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", global_position - Vector2(randf_range(-64, 64), 128), 1.0)
	tween.tween_interval(1.0)
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "global_position", Vector2(randf_range(400, 620), 0), 0.5)
	tween.parallel().tween_property(self, "scale", Vector2(0.1, 0.1), 3.0)

func pick_random_sound() -> void:
	match randi() % 4:
		0:
			audio_stream_player_2d.stream = load("uid://dcjfd8qacu1oy")
		1:
			audio_stream_player_2d.stream = load("uid://ds8vtskp2h24r")
		2:
			audio_stream_player_2d.stream = load("uid://c2axp40ojb446")
		3:
			audio_stream_player_2d.stream = load("uid://bm0lepvcyxakt")

func _on_area_2d_area_entered(area: Area2D) -> void:
	delete_self_collision(area)

func delete_self_collision(area: Area2D) -> void:
	if !is_queued_for_deletion():
		if not area.get_parent() is BigCatcoin:
			Coins.deposit(payout)
			queue_free()

func delete_self() -> void:
	if !is_queued_for_deletion():
		Coins.deposit(payout)
		get_tree().call_group("catcoin_display", "update")
		queue_free()

func _on_timer_timeout() -> void:
	delete_self()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	delete_self()
