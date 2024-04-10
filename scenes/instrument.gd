extends Node

@export var stream: AudioStream
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

var kick = preload("res://sounds/mc2.wav")
var snare = preload("res://sounds/mc1.wav")

var cats_per_beat: Array[int]
var beat: int
func _process(delta: float) -> void:
	print(cats_per_beat)
	print(beat)

func _ready() -> void:
	cats_per_beat.resize(32)
	var note: float = 0.0
	for child:AudioStreamPlayer in get_children():
		child.pitch_scale = root_of_two(note)
		child.max_polyphony = 1
		child.volume_db = -12
		child.stream = stream
		note += 1
		if is_drum:
			child.max_polyphony = 1
			child.volume_db = -6
			unison.stream = kick
			unison.pitch_scale = 2**(-6.0/12.0)
			unison.volume_db = -6
			minor_second.stream = snare
			minor_second.volume_db = -18

func _on_beat(_beat: int, measures: Array, wait_time: float) -> void:
	beat = _beat

func _on_feline_registered(cat_beat: int) -> void:
	cats_per_beat[cat_beat] += 1

func root_of_two(n: float) -> float:
	return 2 ** (n / 12.0)

func _on_note_played(notes) -> void:
	if notes[0]:
		unison.play()
	if notes[1]:
		minor_second.play()
	if notes[2]:
		major_second.play()
	if notes[3]:
		minor_third.play()
	if notes[4]:
		major_third.play()
	if notes[5]:
		perfect_fourth.play()
	if notes[6]:
		tritone.play()
	if notes[7]:
		perfect_fifth.play()
	if notes[8]:
		major_sixth.play()
	if notes[9]:
		minor_seventh.play()
	if notes[10]:
		major_seventh.play()
	if notes[11]:
		octave.play()
