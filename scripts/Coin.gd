extends Area2D

func _on_Coin_body_entered(body: Node) -> void:
	if body is Player:
		body.emit_signal("collect")
		queue_free()
