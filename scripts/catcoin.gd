class_name Catcoin extends AnimatedSprite2D

var payout: float

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	pick_random_sound()
	audio_stream_player_2d.play()
	animate()

func animate() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", global_position + Vector2(0, -16), 0.46875)
	tween.tween_callback(stop)
	tween.tween_property(self, "frame", 0, 0.117188)
	tween.tween_property(self, "global_position", Vector2(620, 0), 0.351562)
	tween.tween_callback(delete_self)

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

func delete_self() -> void:
	Coins.deposit(payout)
	get_tree().call_group("catcoin_display", "update")
	queue_free()


func _on_timer_timeout() -> void:
	if !is_queued_for_deletion():
		delete_self()
