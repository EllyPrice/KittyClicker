class_name CatContainer extends Container

@export_category("Catcoins")
@export var cost: float = 15
@export var payout: float = 1

@export_category("Cat")
@export var cat_sprite: Texture2D = preload("res://images/cats/bob.png")
@export var spriteframes: SpriteFrames

@export_category("Sound")
@export var sound: AudioStreamWAV = preload("res://sounds/cute_anime_nya.wav")

@export_group("Notes")
@export var root: bool
@export var octave: bool
@export var major_sixth: bool
@export var perfect_fifth: bool
@export var perfect_fourth: bool
@export var major_third: bool
@export var minor_third: bool

@onready var adopt_button: TextureButton = %AdoptButton
@onready var floating_text: AnimatedSprite2D = %FloatingText
@onready var cost_label: Label = %CostLabel
@onready var adopt_timer: Timer = %AdoptTimer

const CAT: PackedScene = preload("uid://dwkobg4lwotb4")

var notes: Dictionary
var unlocked: bool = false

signal pressed(cat: Cat)

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
		notes = {
			"root": root,
			"octave": octave,
			"major_sixth": major_sixth,
			"perfect_fifth": perfect_fifth,
			"perfect_fourth": perfect_fourth,
			"major_third": major_third,
			"minor_third": minor_third,
		}
		Coins.withdraw(cost)
		cost *= 1.15
		set_cost_label()
		make_cat()

func make_cat() -> void:
		var cat: Cat = CAT.instantiate()
		cat.notes = notes
		cat.payout = payout
		cat.sound = sound
		cat.spriteframes = spriteframes
		pressed.emit(cat)

func get_used_node_intervals(used_note_intervals: Array) -> Array[float]:
	var note_intervals: Array[float] = [
		1.0/1.0, # Root 1:1
		2.0/2.0, # Octave 2:1
		5.0/3.0, # Major Sixth 5:3
		3.0/2.0, # Perfect Fifth 3:2
		4.0/3.0, # Perfect Fourth 4:3
		5.0/4.0, # Major Third 5:4
		6.0/5.0, # Minor Third 6:5
	]

	if notes["root"] == true:
		used_note_intervals.push_back(note_intervals[0])
	if notes["octave"] == true:
		used_note_intervals.push_back(note_intervals[1])
	if notes["major_sixth"] == true:
		used_note_intervals.push_back(note_intervals[2])
	if notes["perfect_fifth"] == true:
		used_note_intervals.push_back(note_intervals[3])
	if notes["perfect_fourth"] == true:
		used_note_intervals.push_back(note_intervals[4])
	if notes["major_third"] == true:
		used_note_intervals.push_back(note_intervals[5])
	if notes["minor_third"] == true:
		used_note_intervals.push_back(note_intervals[6])

	return used_note_intervals
