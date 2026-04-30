extends Area2D
class_name ShadowGate

@export var souls_required: int = 3
@export var zone_id: int = 1

var souls_collected: int = 0
var is_dissolved: bool = false

signal gate_dissolved(zone_id: int)
signal soul_collected(current: int, required: int)

func _ready():
	# Place on Enemy layer so Kaito's attacks (which now target Layer 3) can hit it
	set_collision_layer_value(1, false)
	set_collision_layer_value(3, true)
	
	# Wait one frame to ensure all enemies are in the scene tree before connecting
	await get_tree().process_frame
	var enemies = get_tree().get_nodes_in_group("zone_" + str(zone_id))
	for enemy in enemies:
		if enemy.has_signal("soul_released"):
			enemy.soul_released.connect(_on_soul_released)

func _on_soul_released():
	if is_dissolved:
		return
	souls_collected += 1
	emit_signal("soul_collected", souls_collected, souls_required)
	if souls_collected >= souls_required:
		dissolve()

func add_soul():
	_on_soul_released()

func dissolve():
	is_dissolved = true
	$CollisionShape2D.set_deferred("disabled", true)
	emit_signal("gate_dissolved", zone_id)
	await get_tree().create_timer(0.5).timeout
	queue_free()
