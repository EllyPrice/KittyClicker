extends MarginContainer

@onready var anim_sprite: AnimatedSprite2D = %AnimSprite
@onready var emote_label: Label = %EmoteLabel
@onready var pet_kitty_button: Button = %PetKittyButton
@onready var sleep_timer: Timer = %SleepTimer
@onready var nyaa_kitty_sound: AudioStreamPlayer2D = %NyaaKittySound
@onready var pet_label: Label = %PetLabel
@onready var hide_emote_timer: Timer = %HideEmoteTimer
@onready var auto_pet_timer: Timer = %AutoPetTimer
@onready var coin_spawner: Node2D = %CoinSpawner

const CATCOIN = preload("res://scenes/big_catcoin.tscn")

var payout: float = 1
var beat: int
var count: int = 0
var switch_note: bool = false
var intro_pos: int = 0
var used_emotes: Array[String]
var anim_sprite_base_pos: Vector2


func _input(event: InputEvent) -> void:
	if event:
		coin_spawner.global_position = get_global_mouse_position()
	if event.is_action_pressed("skip"):
		intro_pos += 100
		CatData.is_intro_finished = true

func _on_pet_kitty_button_pressed() -> void:
	_pet_kitty()
	auto_pet_timer.start(0.468)

func _on_auto_pet_timer_timeout() -> void:
	if pet_kitty_button.button_pressed or Input.is_action_pressed("pet"):
		_pet_kitty()
		sleep_timer.start(1.0)
		auto_pet_timer.start(0.234)
		await get_tree().process_frame

func _on_sleep_timer_timeout() -> void:
	anim_sprite.animation = "idle"
	anim_sprite.frame = 0
	anim_sprite.stop()


func _on_pet_kitty_button_mouse_entered() -> void:
	pet_label.show()
	await Helpers.tree_timer(1.0)
	pet_label.hide()


func _on_pet_kitty_button_mouse_exited() -> void:
	pet_label.hide()


func _on_hide_emote_timer_timeout() -> void:
	emote_label.text = ""

func _pet_kitty() -> void:
	count += 1

	anim_sprite_base_pos = anim_sprite.global_position

	for i: int in 4:
		anim_sprite.global_position += Math.randv(1.0)
		await get_tree().process_frame

	anim_sprite.global_position = anim_sprite_base_pos

	if (count % 4) == 0:
		_do_emote()

	if CatData.is_intro_finished:
		_deposit_payout()


func _flip_sprite() -> void:
	if !anim_sprite.is_playing():
		var coinflip: bool = Math.coinflip()
		anim_sprite.flip_h = coinflip
	match Math.randmod(10):
		0:
			anim_sprite.play("meow")
			await Helpers.tree_timer(1.0)
			anim_sprite.play_backwards("walk")
		2:
			anim_sprite.play("meow")
			await Helpers.tree_timer(1.0)
			anim_sprite.play("walk")
			sleep_timer.start(1.0)
		_:
			anim_sprite.play("meow")
			sleep_timer.start(0.25)


func _deposit_payout() -> void:
	var catcoin: Node2D = CATCOIN.instantiate()
	var tween: Tween = get_tree().create_tween()
	catcoin.scale = Vector2(0.2, 0.2)
	catcoin.payout = payout
	coin_spawner.add_child(catcoin)

	tween.set_parallel(true)
	tween.tween_property(catcoin, "global_position", catcoin.global_position - Vector2(0, 64), 0.5)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(catcoin, "global_position", catcoin.global_position - Vector2(randf_range(-64, 64), 512), 3.0)
	tween.parallel().tween_property(catcoin, "scale", Vector2(0.1, 0.1), 3.0)

func _do_emote() -> void:
	if intro_pos < Emotes.intro.size():
		_do_intro()
	elif Coins.amount > 15 and CatData.first_cat_bought == false:
			emote_label.text = ["Are you gonna buy one?", "meow", "mrowr"].pick_random()
	else:
		match randi() % 4:
			0:
				var random_emote: String = Emotes.big_gato.pick_random()
				if used_emotes.size() >= Emotes.big_gato.size():
					used_emotes.clear()
				if random_emote not in used_emotes:
					emote_label.text = random_emote
					used_emotes.push_back(random_emote)
				else:
					_do_emote()
			_:
				emote_label.text = ""
	if !emote_label.text == "":
		emote_label.show()
		switch_note = !switch_note
		nyaa_kitty_sound.play()
		_flip_sprite()
		hide_emote_timer.start(2)

var meowboy_cat: Cat
func _do_intro() -> void:
	emote_label.text = Emotes.intro[min(intro_pos, Emotes.intro.size()-1)]
	intro_pos += 1
	if emote_label.text == "CATS!":
		get_tree().call_group("starter_cat", "spawn_starter")
	if emote_label.text == "hats?":
		meowboy_cat = CatData.cats.front()
		meowboy_cat.get_child(1).add_child(load("res://scenes/meowboy_hat.tscn").instantiate())
		meowboy_cat.is_cowboy = true
	if emote_label.text == "now give that back":
		CatData.is_intro_finished = true
		meowboy_cat.get_child(1).get_child(0).queue_free()
		meowboy_cat.is_cowboy = false

func _on_intro_timer_timeout() -> void:
	if !CatData.is_intro_finished:
		_do_emote()
	else:
		$IntroTimer.queue_free()
