extends AnimatedSprite2D

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _on_timer_timeout() -> void:
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
