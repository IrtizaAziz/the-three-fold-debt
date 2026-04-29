extends Node2D
class_name CrimsonArcher

@export var fire_rate: float = 2.0
@export var detection_radius: float = 300.0
@export var max_health: float = 25.0
@export var arrow_scene: PackedScene
@export var zone_id: int = 1
@export var facing_direction: float = -1.0 # -1=left, 1=right

signal soul_released

var current_health: float
var player_in_range: bool = false

@onready var detection_area = $DetectionArea
@onready var fire_timer = $FireTimer
@onready var arrow_spawn_point = $ArrowSpawnPoint

func _ready():
	current_health = max_health
	
	if detection_area:
		var shape = detection_area.get_node("CollisionShape2D")
		if shape and shape.shape is CircleShape2D:
			(shape.shape as CircleShape2D).radius = detection_radius
			
		detection_area.body_entered.connect(_on_detection_body_entered)
		detection_area.body_exited.connect(_on_detection_body_exited)
		
	if fire_timer:
		fire_timer.wait_time = fire_rate
		fire_timer.timeout.connect(_on_fire_timer_timeout)

func _on_detection_body_entered(body: Node2D):
	if body.is_in_group("player"):
		player_in_range = true
		if fire_timer:
			fire_timer.start()

func _on_detection_body_exited(body: Node2D):
	if body.is_in_group("player"):
		player_in_range = false
		if fire_timer:
			fire_timer.stop()

func _on_fire_timer_timeout():
	if not player_in_range:
		return
		
	if arrow_scene:
		var arrow = arrow_scene.instantiate()
		arrow.direction = facing_direction
		arrow.archer_owner = self
		
		# Add to parent to avoid moving with the archer
		get_parent().add_child(arrow)
		
		if arrow_spawn_point:
			arrow.global_position = arrow_spawn_point.global_position
		else:
			arrow.global_position = global_position

func take_damage(amount: float):
	current_health -= amount
	if current_health <= 0:
		emit_signal("soul_released")
		queue_free()
