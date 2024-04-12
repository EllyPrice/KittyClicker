class_name Cat extends Node2D

@onready var emote_label: Label = $EmoteLabel
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var shadow: Sprite2D = $Shadow

const CATCOIN = preload("res://scenes/catcoin.tscn")
var flipped: bool = false
var catid: int
var dir: Vector2 = Vector2.ZERO
var is_moving: bool = false
var payout: float = 1
var spriteframes: SpriteFrames

var instrument: StringName
var note: int
var my_beat: int
var bpm: float
var registered: bool

func _ready() -> void:
	anim_sprite.sprite_frames = spriteframes

func _on_beat(beat: int, measures: Array, wait_time: float) -> void:
	bpm = wait_time
	if my_beat not in measures:
		my_beat = beat
		if !registered:
			get_tree().call_group(instrument, "_on_cat_registered", beat, note)
			registered = true
	if my_beat == beat:
		_on_my_beat()
	update()

func _on_my_beat() -> void:
	pick_random_direction()
	emote()
	deposit_payout()
	is_moving = !is_moving
	animate()

func animate() -> void:
	anim_sprite.stop()
	anim_sprite.animation = "meow"
	anim_sprite.frame = 0
	await Helpers.tree_timer(bpm*2)
	if is_moving:
		anim_sprite.play("walk")
	else:
		anim_sprite.play("idle")

func update() -> void:
	anim_sprite.flip_h = dir.x < 0.0
	if is_moving:
		for i: int in 2:
			dir = avoid_boundaries(dir)
			var new_pos: Vector2 = global_position + dir
			var new_pos_x: float = new_pos.x
			var new_pos_y: float = new_pos.y

			new_pos.x = snappedi(new_pos_x, 1)
			new_pos.y = snappedi(new_pos_y, 1)

			global_position = new_pos
			await Helpers.tree_timer(bpm)

func pick_random_direction() -> void:
	match Math.randmod(8):
		0: dir = Vector2.RIGHT
		1: dir = Vector2.LEFT
		2: dir = Vector2.DOWN
		3: dir = Vector2.UP
		4: dir = Vector2(1, 1)
		5: dir = Vector2(-1, 1)
		6: dir = Vector2(1, -1)
		7: dir = Vector2(-1, -1)

func avoid_boundaries(_dir: Vector2) -> Vector2:
	const PADDING: int = 64
	const START: Vector2 = Vector2(PADDING, PADDING)
	var end: Vector2 = Vector2(400, 576) - START
	if global_position.x > end.x:
		_dir.x = -1
	if global_position.y > end.y:
		_dir.y = -1
	if global_position.x < START.x:
		_dir.x = 1
	if global_position.y < START.y:
		_dir.y = 1
	return _dir

var count: int = 0
func emote() -> void:
	var text_emotes: GDScript = preload("res://scripts/emotes.gd")

	emote_label.text = text_emotes.amiguito.pick_random()
	emote_label.show()
	await Helpers.tree_timer(bpm*4)
	emote_label.hide()

func deposit_payout() -> void:
	var catcoin: Node2D = CATCOIN.instantiate()
	var tween: Tween = get_tree().create_tween()

	add_child(catcoin)
	tween.tween_property(catcoin, "global_position", catcoin.global_position + Vector2(0, -16), 0.5)
	tween.tween_callback(delete_coin.bind(catcoin))

	Coins.deposit(payout)

func delete_coin(catcoin: Node) -> void:
	catcoin.queue_free()
	emote_label.hide()

func _on_bar() -> void:
	pass
