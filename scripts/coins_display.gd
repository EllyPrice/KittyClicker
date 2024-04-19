extends Node2D

var last_text: String

var sounds: Array[AudioStreamWAV] = [
	load("uid://cpkp2oy8xbvcl"),
	load("uid://kq4vtq3hgn07"),
	load("uid://cma6elnhcio0m"),
]

@onready var beat_tracker_half: Timer = %BeatTrackerHalf
@onready var sprite: Sprite2D = $Sprite2D
@onready var label: Label = $Label
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	label.text = "%s catcoins" % Math.format_large_number(Coins.amount)


func _input(_event: InputEvent) -> void:
	update()


func _on_area_2d_area_entered(_area: Area2D) -> void:
	animate_and_play_sound()
	update()


func update() -> void:
	var new_text: String = "%s catcoins" % Math.format_large_number(Coins.amount)
	if new_text != last_text:
		label.text = "%s catcoins" % Math.format_large_number(Coins.amount)
		await tree_timer(.1).timeout

func tree_timer(wait_time: float) -> SceneTreeTimer:
	return get_tree().create_timer(wait_time)

func animate_and_play_sound() -> void:
	var tween: Tween = get_tree().create_tween()

	tween.tween_property(label, "scale", label.scale * 1.05, 0.1)
	tween.parallel().tween_property(sprite, "scale", sprite.scale * 1.05, 0.1)

	tween.tween_property(label, "scale", Vector2(1.0, 1.0), 0.15)
	tween.parallel().tween_property(sprite, "scale", Vector2(2.0, 2.0), 0.15)

	await beat_tracker_half.timeout
	pick_next_sound()
	audio_stream_player.play()

func pick_next_sound() -> void:
	audio_stream_player.stream = sounds.pick_random()
