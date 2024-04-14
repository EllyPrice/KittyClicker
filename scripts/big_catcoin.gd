extends AnimatedSprite2D
class_name BigCatcoin

var payout: float

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	match randi() % 4:
		0:
			audio_stream_player_2d.stream = load("uid://dcjfd8qacu1oy")
		1:
			audio_stream_player_2d.stream = load("uid://ds8vtskp2h24r")
		2:
			audio_stream_player_2d.stream = load("uid://c2axp40ojb446")
		3:
			audio_stream_player_2d.stream = load("uid://bm0lepvcyxakt")
	audio_stream_player_2d.play()

func _on_area_2d_area_entered(area: Area2D) -> void:
	delete_self_collision(area)

func delete_self_collision(area: Area2D) -> void:
	if not area.get_parent() is BigCatcoin:
		Coins.deposit(payout)
		queue_free()

func delete_self() -> void:
	Coins.deposit(payout)
	queue_free()

func _on_timer_timeout() -> void:
	delete_self()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	delete_self()
