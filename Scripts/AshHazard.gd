extends Area2D
class_name AshHazard

## A falling ash projectile spawned during The Captain's Roar attack.
## Falls at a fixed speed and deals chip damage if the player is outside Hana's light.

@export var fall_speed: float = 200.0
@export var chip_damage: float = 1.5   # = roar_damage_per_second * 0.3s interval

func _ready():
	body_entered.connect(_on_body_entered)
	# Auto-destroy after 5 seconds in case it misses everything
	get_tree().create_timer(5.0).timeout.connect(func():
		if is_instance_valid(self): queue_free()
	)

func _process(delta: float):
	# Falls downward every frame — simple, no accumulating connections
	position.y += fall_speed * delta

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		# Only deal damage if player is outside Hana's light
		var is_safe = false
		var hana_light = body.get_node_or_null("Hana/HanaLightRadius")
		if hana_light and body in hana_light.get_overlapping_bodies():
			is_safe = true

		if not is_safe and body.has_method("take_damage"):
			body.take_damage(chip_damage)

	queue_free()
