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
var current_radius: float
var ren: Node2D
var hana_light_radius: Area2D
@onready var point_light = $PointLight2D

const MIN_LIGHT_RADIUS: float = 40.0  # Never shrink below this; player must always have a safe zone

func _ready():
	# Hana is a child of Player; top_level detaches her transform so she can smoothly follow
	ren = get_parent()
	hana_light_radius = $HanaLightRadius
	top_level = true
	
	current_radius = light_radius
	_update_visuals()
	
	if ren:
		global_position = ren.global_position

func _physics_process(delta: float):
	if not ren:
		return
		
	# Recover radius very slowly over time (reduced drastically to 1.5 pixels per second)
	if current_radius < light_radius:
		current_radius = min(light_radius, current_radius + 1.5 * delta)
		_update_visuals()
	
	# Calculate how strong Hana is (1.0 at full light, approaches 0 as she shrinks)
	var strength_ratio = current_radius / light_radius
	# She should NEVER perfectly keep up. We multiply her base speed by 0.4 to force her to lag.
	# If she is fully weak, she follows at a snail's pace.
	var dynamic_follow_speed = (follow_speed * 0.4) * max(0.2, strength_ratio)
	
	# Smoothly trail behind Ren's position — the lag creates a ghostly feel
	global_position = global_position.lerp(ren.global_position, dynamic_follow_speed * delta)
	
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
	current_radius = max(current_radius * (1.0 - percentage), MIN_LIGHT_RADIUS)
	_update_visuals()

func _update_visuals():
	if hana_light_radius:
		var shape = hana_light_radius.get_node("CollisionShape2D")
		if shape and shape.shape is CircleShape2D:
			(shape.shape as CircleShape2D).radius = current_radius
			
	if point_light:
		# Keep visual light mapped to the physical radius (150 radius = 2.0 scale)
		point_light.texture_scale = current_radius / 75.0

