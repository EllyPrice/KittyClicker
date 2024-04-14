class_name CatContainer extends Container

signal pressed(cat: Cat)

@export_category("Catcoins")
@export var cost: float = 15
@export var payout: float = 1

@export_category("Cat")
@export var cat_sprite: Texture2D = preload("res://images/cats/bob.png")
@export var spriteframes: SpriteFrames

@export_category("Sound")
@export var sound: AudioStream

@export_group("Notes")
@export var unison: bool
@export var minor_second: bool
@export var major_second: bool
@export var minor_third: bool
@export var major_third: bool
@export var perfect_fourth: bool
@export var tritone: bool
@export var perfect_fifth: bool
@export var major_sixth: bool
@export var minor_seventh: bool
@export var major_seventh: bool
@export var octave: bool

@onready var adopt_button: TextureButton = %AdoptButton
@onready var floating_text: AnimatedSprite2D = %FloatingText
@onready var cost_label: Label = %CostLabel
@onready var adopt_timer: Timer = %AdoptTimer

const CAT: PackedScene = preload("uid://dwkobg4lwotb4")

var unlocked: bool = false

func _ready() -> void:
	adopt_button.texture_normal = cat_sprite
	set_cost_label()

func _process(delta: float) -> void:
	if CatData.is_intro_finished:
		if Coins.amount > cost:
			show()

func _on_adopt_button_mouse_entered() -> void:
	floating_text.show()

func _on_adopt_button_mouse_exited() -> void:
	floating_text.hide()

func _on_adopt_button_pressed() -> void:
	adopt_timer.start(0.5)
	buy_cat()

func _on_adopt_timer_timeout() -> void:
	if adopt_button.button_pressed:
		adopt_timer.start(0.1)
		buy_cat()

func set_cost_label() -> void:
	cost_label.text = Math.format_large_number(cost)

func buy_cat() -> void:
	if (Coins.amount - cost) >= 0:
		if CatData.first_cat_bought == false:
			CatData.first_cat_bought = true
		Coins.withdraw(cost)
		cost *= 1.15
		set_cost_label()
		make_cat()

func make_cat() -> void:
	var notes: Array[bool] = [
		unison,
		minor_second,
		major_second,
		minor_third,
		major_third,
		perfect_fourth,
		tritone,
		perfect_fifth,
		major_sixth,
		minor_seventh,
		major_seventh,
		octave,
	]
	var note: int
	for n: int in notes.size():
		if notes[n] == true:
			note = n
	var cat: Cat = CAT.instantiate()
	cat.payout = payout
	cat.sound = sound
	cat.note = note
	cat.spriteframes = spriteframes
	pressed.emit(cat)

func spawn_starter() -> void:
	make_cat()
