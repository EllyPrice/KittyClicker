extends AnimatedSprite2D
class_name BigCatcoin

var payout: float

func _on_area_2d_area_entered(area: Area2D) -> void:
	delete_self_collision(area)

func delete_self_collision(area: Area2D) -> void:
	if not area.get_parent() is BigCatcoin:
		Coins.deposit(payout)
		queue_free()

func delete_self() -> void:
	Coins.deposit(payout)
	queue_free()

func _on_timer_timeout() -> void:
	delete_self()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	delete_self()
