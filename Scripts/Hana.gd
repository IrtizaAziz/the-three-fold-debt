extends Node2D
class_name Hana

signal gloom_changed(value: float)
signal player_died

@export var follow_speed: float = 5.0
@export var gloom_rate: float = 10.0
@export var gloom_recovery: float = 5.0
@export var max_gloom: float = 100.0
@export var light_radius: float = 150.0  # Exported so it can be tuned in the inspector

var current_gloom: float = 0.0
var ren: Node2D
var hana_light_radius: Area2D

const MIN_LIGHT_RADIUS: float = 40.0  # Never shrink below this; player must always have a safe zone

func _ready():
	# Hana is a child of Player; top_level detaches her transform so she can smoothly follow
	ren = get_parent()
	hana_light_radius = $HanaLightRadius
	top_level = true
	
	# Apply the exported radius to the CircleShape2D on startup
	if hana_light_radius:
		var shape = hana_light_radius.get_node("CollisionShape2D")
		if shape and shape.shape is CircleShape2D:
			(shape.shape as CircleShape2D).radius = light_radius
	
	if ren:
		global_position = ren.global_position

func _physics_process(delta: float):
	if not ren:
		return
	
	# Smoothly trail behind Ren's position — the lag creates a ghostly feel
	global_position = global_position.lerp(ren.global_position, follow_speed * delta)
	
	if not hana_light_radius:
		return
	
	# Check if Ren's body is inside the safe zone using get_overlapping_bodies()
	var is_ren_safe = false
	for body in hana_light_radius.get_overlapping_bodies():
		if body == ren:
			is_ren_safe = true
			break
	
	if not is_ren_safe:
		current_gloom += gloom_rate * delta
		if current_gloom >= max_gloom:
			current_gloom = max_gloom
			emit_signal("player_died")
	else:
		current_gloom = max(0.0, current_gloom - gloom_recovery * delta)
	
	# Emit every frame so the HUD can react smoothly
	emit_signal("gloom_changed", current_gloom)

func reduce_light(percentage: float):
	# Called by Gloom Wisps on contact — shrinks the safe zone by the given percentage
	if not hana_light_radius:
		return
	var shape = hana_light_radius.get_node("CollisionShape2D")
	if shape and shape.shape is CircleShape2D:
		var circle = shape.shape as CircleShape2D
		var new_radius = circle.radius * (1.0 - percentage)
		circle.radius = max(new_radius, MIN_LIGHT_RADIUS)  # Never shrink below 40px

