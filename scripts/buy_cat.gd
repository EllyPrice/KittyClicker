class_name CatContainer extends Container

signal pressed(cat: Cat)

@export_category("Catcoins")
@export var cost: float = 15
@export var payout: float = 1

@export_category("Cat")
@export var cat_sprite: Texture2D = preload("res://images/cats/bob.png")
@export var spriteframes: SpriteFrames

@export_category("Sound")
@export var sound: AudioStreamWAV = preload("res://sounds/cute_anime_nya.wav")

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
@export var augmented_sixth: bool
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
		var notes: Array[float] = [
		float(unison) * root_of_two(0.0),
		float(minor_second) * root_of_two(1.0),
		float(major_second) * root_of_two(2.0),
		float(minor_third) * root_of_two(3.0),
		float(major_third) * root_of_two(4.0),
		float(perfect_fourth) * root_of_two(5.0),
		float(tritone) * root_of_two(6.0),
		float(perfect_fifth) * root_of_two(7.0),
		float(major_sixth) * root_of_two(9.0),
		float(minor_seventh) * root_of_two(10.0),
		float(major_seventh) * root_of_two(11.0),
		float(octave) * root_of_two(12.0),
		]
		var used_notes: Array[float]
		for i in notes.size():
			if notes[i] >= 1:
				used_notes.append(notes[i])

		Coins.withdraw(cost)
		cost *= 1.15
		set_cost_label()
		make_cat(used_notes)

func root_of_two(n: float) -> float:
	return 2 ** (n / 12.0)

func make_cat(notes: Array[float]) -> void:
	var cat: Cat = CAT.instantiate()
	cat.payout = payout
	cat.sound = sound
	cat.notes = notes
	cat.spriteframes = spriteframes
	pressed.emit(cat)
	print(notes)

