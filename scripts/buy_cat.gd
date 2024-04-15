class_name CatContainer extends BuyButton

signal pressed(cat: Cat)

@export var is_kick: bool
@export var is_snare: bool
@export var is_cowboy: bool

@export_category("Catcoins")
@export var cost: float = 15
@export var payout: float = 1

@export_category("Cat")
@export var cat_sprite: Texture2D = preload("res://images/cats/bob.png")
@export var spriteframes: SpriteFrames

@export_category("Text")
@export var text_color: Color = Color.WHITE

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
var locked_texture: Texture2D = preload("res://images/cats/cat_icon.png")
var number_owned: int = 0
var base_cost: float

func _ready() -> void:
	adopt_button.texture_normal = locked_texture
	set_cost_label()
	base_cost = cost

func _process(_delta: float) -> void:
	if CatData.is_intro_finished:
		if Coins.amount > cost:
			adopt_button.texture_normal = cat_sprite
	if (cost/2.0) < Coins.amount:
		show()
	if cost > Coins.amount and visible:
		modulate = Color.GRAY
	else:
		modulate = Color.WHITE

func _on_adopt_button_mouse_entered() -> void:
	if cost <= Coins.amount:
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
		floating_text.hide()
		modulate = Color.GRAY
		Coins.withdraw(cost)
		number_owned += 1
		cost = base_cost * (1.15 ** number_owned)
		set_cost_label()
		make_cat()

		if CatData.first_cat_bought == false:
			CatData.first_cat_bought = true


func make_cat() -> void:
	var notes: Array[bool] = [unison, minor_second, major_second, minor_third, major_third, perfect_fourth, tritone, perfect_fifth, major_sixth, minor_seventh, major_seventh, octave, ]
	var note: int
	var cat: Cat = CAT.instantiate()

	for n: int in notes.size():
		if notes[n] == true:
			note = n

	cat.payout = payout
	cat.sound = sound
	cat.note = note
	cat.text_color = text_color
	cat.spriteframes = spriteframes
	pressed.emit(cat)

func spawn_starter() -> void:
	make_cat()

