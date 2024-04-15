class_name Cat extends Node2D

signal lured(pos: Vector2)

const CATCOIN: PackedScene = preload("res://scenes/catcoin.tscn")

var flipped: bool = false
var catid: int
var is_moving: bool = false
var payout: float = 1
var spriteframes: SpriteFrames

var note: int
var my_beat: int
var registered: bool
var is_kick: bool
var is_snare: bool
var is_cowboy: bool
var sound: AudioStream
var original_sound: AudioStream
var text_color: Color

@onready var emote_label: CatEmoteLabel = $EmoteLabel
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var shadow: Sprite2D = $Shadow
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready() -> void:
	original_sound = sound
	anim_sprite.sprite_frames = spriteframes
	audio_stream_player_2d.stream = sound
	audio_stream_player_2d.pitch_scale = 2.0 ** (note/12.0)
	emote_label.text_color = text_color
	CatData.cats.push_front(self)
	CatData.cat_positions.push_back(global_position)


func _on_beat_listener_assigned_beat_played() -> void:
	_on_my_beat()


func _on_my_beat() -> void:
	is_moving = !is_moving
	spawn_catcoin()

	for i: int in randi_range(0, 2):
		await get_tree().process_frame

	if is_cowboy:
		audio_stream_player_2d.stream = load("uid://dq7bdv4vwnyyn")

	elif audio_stream_player_2d.stream != original_sound:
		audio_stream_player_2d.stream = original_sound

	audio_stream_player_2d.play()


func spawn_catcoin() -> void:
	var catcoin: Catcoin = CATCOIN.instantiate()
	catcoin.payout = payout
	catcoin.position.y -= 16
	add_child(catcoin)


func add_hat(hat: Hat) -> void:
	is_cowboy = true
	hat.global_position = anim_sprite.global_position
	hat.flip_h = anim_sprite.flip_h
	hat.reparent(anim_sprite)


func remove_hat() -> void:
	for child: Hat in anim_sprite.get_children():
		if child is Hat:
			child.queue_free()
	if is_cowboy:
		is_cowboy = false


func lure(pos: Vector2) -> void:
	lured.emit(pos)
