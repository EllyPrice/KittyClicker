class_name CatEmoteLabel extends Label

var is_cowboy: bool = false
var is_kick: bool = false
var is_snare: bool = false
var text_color: Color

@onready var timer: Timer = $Timer

func _on_beat_listener_assigned_beat_played() -> void:
	emote()

func emote() -> void:
	if is_cowboy:
		text = Emotes.meowboy.pick_random()
		modulate = Color.DARK_RED

	elif is_kick:
		text = Emotes.kick.pick_random()

	elif is_snare:
		text = Emotes.snare.pick_random()

	else:
		text = Emotes.amiguito.pick_random()
		modulate = text_color

	show()
	timer.start(2.0)


func _on_timer_timeout() -> void:
	hide()

