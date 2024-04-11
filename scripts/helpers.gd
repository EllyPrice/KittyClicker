extends Node

func tree_timer(wait_time: float) -> Signal:
	return get_tree().create_timer(wait_time).timeout
