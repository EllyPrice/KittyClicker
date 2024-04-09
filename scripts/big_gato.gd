extends MarginContainer

@onready var anim_sprite: AnimatedSprite2D = %AnimSprite
@onready var emote_label: Label = %EmoteLabel
@onready var pet_kitty_button: Button = %PetKittyButton
@onready var pet_timer: Timer = %PetTimer
@onready var sleep_timer: Timer = %SleepTimer
@onready var nyaa_kitty_sound: AudioStreamPlayer2D = %NyaaKittySound
@onready var pet_label: Label = %PetLabel
@onready var hide_emote_timer: Timer = %HideEmoteTimer

var beat: int
var count: int = 0

func _on_pet_kitty_button_pressed() -> void:
	pet_kitty()
	pet_timer.start(0.468)

func pet_kitty() -> void:
	count += 1
	Coins.deposit(1)

	var anim_sprite_base_pos: Vector2 = anim_sprite.global_position
	for i: int in 4:
		anim_sprite.global_position += Math.randv(.5)
		await get_tree().process_frame
	anim_sprite.global_position = anim_sprite_base_pos

	if (count % 4) == 0:
		_do_emote()

var switch_note: bool = false
func _do_emote() -> void:
	var text_emotes = preload("res://scripts/emotes.gd")
	emote_label.text = text_emotes.amiguito.pick_random()
	emote_label.show()
	nyaa_kitty_sound.pitch_scale = 2 ** (-12.0 / 12.0)
	switch_note = !switch_note
	nyaa_kitty_sound.play()
	flip_sprite()
	hide_emote_timer.start(2)

func flip_sprite() -> void:
	if !anim_sprite.is_playing():
		anim_sprite.flip_h = Math.coinflip()
	match Math.randmod(10):
		0:
			anim_sprite.play_backwards("walk")
		2:
			anim_sprite.play("walk")
			sleep_timer.start(1.0)
		_:
			anim_sprite.play("meow")
			sleep_timer.start(0.25)

func _on_pet_timer_timeout() -> void:
	if pet_kitty_button.button_pressed or Input.is_action_pressed("pet"):
		pet_kitty()
		sleep_timer.start(1.0)
		pet_timer.start(0.468)
		await get_tree().process_frame

func _on_sleep_timer_timeout() -> void:
	anim_sprite.animation = "idle"
	anim_sprite.frame = 0
	anim_sprite.stop()

func _on_pet_kitty_button_mouse_entered() -> void:
	pet_label.show()

func _on_pet_kitty_button_mouse_exited() -> void:
	pet_label.hide()

func _on_hide_emote_timer_timeout() -> void:
	emote_label.text = ""


func track_beat(_beat: int) -> void:
	beat = _beat

