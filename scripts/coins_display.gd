extends Label

var last_text: String
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	text = "%s catcoins" % Math.format_large_number(Coins.amount)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var new_text: String = "%s catcoins" % Math.format_large_number(Coins.amount)
	if new_text != last_text:
		text = "%s catcoins" % Math.format_large_number(Coins.amount)
		await Helpers.tree_timer(.1)


func _on_area_2d_area_entered(area: Area2D) -> void:
	print("entered")
	var tween: Tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite, "scale", sprite.scale + Vector2(.2, .2), .01)
	tween.parallel().tween_property(sprite, "position", sprite.position + Math.randv(2.0), .01)
	tween.parallel().tween_property(sprite, "position", sprite.position + Math.randv(2.0), .01)
	tween.tween_property(sprite, "scale", Vector2(2, 2), 2.0)
	tween.parallel().tween_property(sprite, "position", Vector2(5, 15), 2.0)
