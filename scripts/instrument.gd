extends Node

@export var stream_1: AudioStream
@export var stream_2: AudioStream
@export var stream_3: AudioStream
@export var stream_4: AudioStream
@export var stream_5: AudioStream
@export var stream_6: AudioStream
@export var stream_7: AudioStream
@export var is_drum: bool

@onready var unison: AudioStreamPlayer = $Unison
@onready var minor_second: AudioStreamPlayer = $MinorSecond
@onready var major_second: AudioStreamPlayer = $MajorSecond
@onready var minor_third: AudioStreamPlayer = $MinorThird
@onready var major_third: AudioStreamPlayer = $MajorThird
@onready var perfect_fourth: AudioStreamPlayer = $PerfectFourth
@onready var tritone: AudioStreamPlayer = $Tritone
@onready var perfect_fifth: AudioStreamPlayer = $PerfectFifth
@onready var major_sixth: AudioStreamPlayer = $MajorSixth
@onready var minor_seventh: AudioStreamPlayer = $MinorSeventh
@onready var major_seventh: AudioStreamPlayer = $MajorSeventh
@onready var octave: AudioStreamPlayer = $Octave

var kick = preload("res://sounds/kick.wav")
var snare = preload("res://sounds/snare.wav")

var sequence: Array
var notes: Array[int]
var beat: int

func _ready() -> void:
	notes.resize(12)
	sequence.resize(33)
	setup_instruments()
	for i: int in get_child_count():
		if get_child(i) is Note:
			var note: Note = get_child(i)
			note.my_note = i
			note.streams = [
				stream_1,
				stream_2,
				stream_3,
				stream_4,
				stream_5,
				stream_6,
				stream_7,
			]

func setup_instruments() -> void:
	var note_to_pitch_scale: float = 0.0
	for child: AudioStreamPlayer in get_children():
		child.pitch_scale = root_of_two(note_to_pitch_scale)
		child.max_polyphony = 1
		child.volume_db = -12
		if !child.stream:
			child.stream = stream_1
		note_to_pitch_scale += 1.0
		if is_drum:
			child.max_polyphony = 1
			child.volume_db = -6
			unison.stream = kick
			unison.pitch_scale = 2 ** (-6.0/12.0)
			unison.volume_db = -6
			minor_second.stream = snare
			minor_second.volume_db = -18

func _on_beat(_beat: int, measures: Array, wait_time: float) -> void:
	beat = _beat

func _on_cat_registered(cat_beat: int, cat_note: int) -> void:
	for child: AudioStreamPlayer in get_children():
		if child is Note:
			var note: Note = child
			note._on_cat_registered(cat_beat, cat_note)

func root_of_two(n: float) -> float:
	return 2 ** (n / 12.0)

