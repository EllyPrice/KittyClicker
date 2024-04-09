extends Timer

var beat: int = 1

func _on_timeout() -> void:
	var measures: Array = range(1, 33)
	if beat < 64:
		beat += 1
	else:
		beat = 1
	get_tree().call_group("cats", "_on_beat", beat, measures)
