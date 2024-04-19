extends MarginContainer

@onready var anim_sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var emote_label: Label = %EmoteLabel
@onready var pet_kitty_button: Button = %PetButton
@onready var sleep_timer: Timer = %SleepTimer
@onready var nyaa_kitty_sound: AudioStreamPlayer2D = %NyaaKittySound
@onready var pet_label: Label = %PetLabel
@onready var hide_emote_timer: Timer = %HideEmoteTimer
@onready var auto_pet_timer: Timer = %AutoPetTimer
@onready var coin_spawner: Node2D = %CoinSpawner

const CATCOIN: PackedScene = preload("res://scenes/big_catcoin.tscn")

var payout: float = 1
var beat: int
var count: int = 0
var switch_note: bool = false
var intro_pos: int = 0
var used_emotes: Array[String]
var original_position: Vector2
var original_scale: Vector2
var meowboy_cat: Cat
var HAT_SCENE: PackedScene = preload("res://scenes/meowboy_hat.tscn")

func _ready() -> void:
	original_position = global_position
	original_scale = anim_sprite.scale

func _input(event: InputEvent) -> void:
	if InputEventMouse:
		if InputEventMouseMotion:
			if event:
				coin_spawner.global_position = get_global_mouse_position()
		if event.is_action_pressed("skip"):
			intro_pos += 100
			CatData.is_intro_finished = true
			get_tree().call_group("hidden_during_intro", "show")
			var tween: Tween = get_tree().create_tween()
			tween.tween_property(self, "global_position", original_position, 1.0)

func _on_pet_button_pressed() -> void:
	pet()
	auto_pet_timer.start(0.468)

#region Timers
func _on_auto_pet_timer_timeout() -> void:
	if pet_kitty_button.button_pressed or Input.is_action_pressed("pet"):
		pet()
		sleep_timer.start(1.0)
		auto_pet_timer.start(0.234)
		await get_tree().process_frame


func _on_sleep_timer_timeout() -> void:
	anim_sprite.animation = "idle"
	anim_sprite.frame = 0
	anim_sprite.stop()


func _on_anim_sprite_animation_finished() -> void:
	anim_sprite.animation = "idle"
	anim_sprite.frame = 0
	anim_sprite.stop()


func _on_pet_button_mouse_entered() -> void:
	pet_label.show()
	await tree_timer(1.0).timeout
	pet_label.hide()


func tree_timer(wait_time: float) -> SceneTreeTimer:
	return get_tree().create_timer(wait_time)

func _on_pet_button_mouse_exited() -> void:
	pet_label.hide()


func _on_hide_emote_timer_timeout() -> void:
	emote_label.text = ""


func _on_intro_timer_timeout() -> void:
	if !CatData.is_intro_finished:
		emote()
	else:
		$IntroTimer.queue_free()
#endregion

func pet() -> void:
	increment_count()

	if CatData.is_intro_finished:
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(anim_sprite, "scale", anim_sprite.scale + Vector2(randf(), randf()), 0.01)
		tween.tween_property(anim_sprite, "scale", original_scale, 0.2)

	if count == 4:
		count = 0
		emote()

	if CatData.is_intro_finished:
		spawn_coin()

func increment_count() -> void:
	count += 1

func flip_sprite() -> void:
	if !anim_sprite.is_playing():
		var coinflip: bool = Math.coinflip()
		anim_sprite.flip_h = coinflip
	match Math.randmod(10):
		0:
			anim_sprite.play("meow")
			await tree_timer(1.0).timeout
			anim_sprite.play_backwards("walk")
		2:
			anim_sprite.play("meow")
			await tree_timer(1.0).timeout
			anim_sprite.play("walk")
			sleep_timer.start(1.0)
		_:
			anim_sprite.play("meow")
			sleep_timer.start(0.25)

func spawn_coin() -> void:
	var catcoin: BigCatcoin = CATCOIN.instantiate()
	catcoin.scale = Vector2(0.2, 0.2)
	catcoin.payout = payout
	coin_spawner.add_child(catcoin)

func emote() -> void:
	if intro_pos < Emotes.intro.size():
		intro()

	elif Coins.amount > 15 and CatData.first_cat_bought == false:
			emote_label.text = ["Are you gonna buy one?", "meow", "mrowr"].pick_random()

	else:
		pick_random_emote()

	if !emote_label.text == "":
		emote_label.show()
		switch_note = !switch_note
		nyaa_kitty_sound.play()
		flip_sprite()
		hide_emote_timer.start(2)

func pick_random_emote() -> void:
	var random_emote: String = Emotes.big_gato.pick_random()
	if used_emotes.size() >= Emotes.big_gato.size():
		used_emotes.clear()
	if random_emote not in used_emotes:
		emote_label.text = random_emote
		used_emotes.push_back(random_emote)
	else:
		pick_random_emote() # Repeat function

func intro() -> void:
	global_position = (get_viewport_rect().size/2.0) - Vector2(80, 80)
	emote_label.text = Emotes.intro[min(intro_pos, Emotes.intro.size()-1)]
	intro_pos += 1

	if emote_label.text == "CATS!":
		create_first_cat_for_free()

	if emote_label.text == "hats?":
		give_first_cat_a_cowboy_hat()

	if emote_label.text == "now give that back":
		end_intro()


func create_first_cat_for_free() -> void:
	get_tree().call_group("starter_cat", "spawn_starter")


func give_first_cat_a_cowboy_hat() -> void:
	meowboy_cat = CatData.cats.front()
	#hat.global_position = meowboy_cat.global_position
	meowboy_cat.add_hat(HAT_SCENE)
	meowboy_cat.is_cowboy = true


func end_intro() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", original_position, 1.0)
	get_tree().call_group("hidden_during_intro", "show")
	CatData.is_intro_finished = true
	meowboy_cat.remove_hat()
	meowboy_cat.is_cowboy = false

