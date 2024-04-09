extends Node

func coinflip() -> bool:
	match randi() % 2:
		0:
			return true
		_:
			return false

func randmod(num: int) -> int:
	return randi() % num

func randv_range(min_x: float = -1, max_x: float = 1, min_y: float = -1, max_y: float = 1, scale: float = 1.0) -> Vector2:
	return Vector2(randf_range(min_x, max_x), randf_range(min_y, max_y)) * scale

func randv(scale: float = 1.0) -> Vector2:
	return Vector2(randf_range(-1, 1), randf_range(-1, 1)) * scale

func format_large_number(number: float) -> String:
	var suffixes: PackedStringArray = ["", "K", "M", "B", "T", "P", "E", "Z", "Y", "R", "Q"]
	if number < 1000:
		return str(snapped(number, 1.0))
	var index: int = 0
	var decimal_number: float = number
	while decimal_number >= 1000 and index < suffixes.size():
		decimal_number /= 1000
		if index < suffixes.size() - 1:
			index += 1
	var formatted_number: String = str(snapped(decimal_number, .01)) + suffixes[index]
	return formatted_number

