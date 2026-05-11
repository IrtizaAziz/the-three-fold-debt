extends Node2D

func _ready():
	await get_tree().process_frame
	if has_node("HUD"):
		$HUD.show_health_bar()
		$HUD.show_gloom_meter()

func _on_kill_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.has_method("take_damage"):
		body.take_damage(body.max_health)
