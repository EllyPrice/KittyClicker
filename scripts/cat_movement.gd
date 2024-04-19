extends Node

@export var parent: Cat

var is_moving: bool = false
var dir: Vector2
var my_id: int
var is_lure_found: bool = false

@onready var animated_sprite_2d: AnimatedSprite2D = $".."
@onready var zoomba: Sprite2D = $"../Zoomba"
@onready var zoomba_up: Sprite2D = $"../ZoombaUp"

func _on_beat_listener_beat_received() -> void:
	update()


func _on_beat_listener_assigned_beat_played() -> void:
	CatData.cat_positions[my_id] = parent.global_position
	if !is_lure_found:
		pick_random_direction()
	is_moving = !is_moving
	animate()


func animate() -> void:
	if Settings.are_animations_on:
		if zoomba.visible or zoomba_up.visible:
			zoomba.hide()
			zoomba_up.hide()
		animated_sprite_2d.stop()
		animated_sprite_2d.animation = "meow"
		animated_sprite_2d.frame = 0
		await tree_timer((0.234375)*2).timeout
		if is_moving:
			if dir.y < 0:
				animated_sprite_2d.play("walk_up")
			else:
				animated_sprite_2d.play("walk")
		else:
			if dir.y < 0:
				animated_sprite_2d.play("idle_up")
			else:
				animated_sprite_2d.play("idle")

	else:
		if dir.y < 0:
			animated_sprite_2d.animation = "idle_up"
			animated_sprite_2d.frame = 0
			zoomba_up.show()
			zoomba.hide()
		else:
			zoomba.show()
			zoomba_up.hide()
			animated_sprite_2d.animation = "idle"
			animated_sprite_2d.frame = 0

func tree_timer(wait_time: float) -> SceneTreeTimer:
	return get_tree().create_timer(wait_time)

func update() -> void:
	if dir.x < 0.0:
		animated_sprite_2d.scale.x = -1
	else:
		animated_sprite_2d.scale.x = 1
	if is_moving:
		for i: int in 2:
			dir = avoid_boundaries(dir)
			var new_pos: Vector2 = parent.global_position + dir
			var new_pos_x: float = new_pos.x
			var new_pos_y: float = new_pos.y

			new_pos.x = snappedi(new_pos_x, 1)
			new_pos.y = snappedi(new_pos_y, 1)

			parent.global_position = new_pos
			await tree_timer(0.234375).timeout

func pick_random_direction() -> void:
	match Math.randmod(8):
		0: dir = Vector2.RIGHT
		1: dir = Vector2.LEFT
		2: dir = Vector2.DOWN
		3: dir = Vector2.UP
		4: dir = Vector2(1, 1)
		5: dir = Vector2(-1, 1)
		6: dir = Vector2(1, -1)
		7: dir = Vector2(-1, -1)


func avoid_boundaries(_dir: Vector2) -> Vector2:
	const START: Vector2 = Vector2(64, 64)
	const END: Vector2 = Vector2(336, 512)
	if parent.global_position.x > END.x:
		_dir.x = -1
	if parent.global_position.y > END.y:
		_dir.y = -1
	if parent.global_position.x < START.x:
		_dir.x = 1
	if parent.global_position.y < START.y:
		_dir.y = 1
	return _dir



func _on_cat_lured(pos: Vector2) -> void:
	is_lure_found = true
	is_moving = true
	dir = parent.global_position.direction_to(pos + Math.randv_range(-1.0, 1.0, -1.0, 1.0, 128.0))
