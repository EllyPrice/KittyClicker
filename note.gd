class_name Note extends AudioStreamPlayer

var my_note: int
var sequence: Array[int]
var streams: Array[AudioStream]

func _ready() -> void:
	sequence.resize(BeatTracker.measure_size)

#func _on_beat(beat: int) -> void:
	#if sequence[beat] > 0:
		#stream = streams[min(sequence[beat]-1, 6)]
		#play()

func _on_cat_registered(cat_beat: int, cat_note: int):
	if cat_note == my_note:
		sequence[cat_beat] += 1

func _on_beat(beat: int, measures: Array, wait_time: float) -> void:
	if sequence[beat] > 0:
		stream = streams[min(sequence[beat]-1, 6)]
		play()
