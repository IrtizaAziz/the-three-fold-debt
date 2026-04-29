extends Node2D
class_name BambooLurker

signal soul_released

@export var attack_damage: float = 15.0
@export var trigger_radius: float = 100.0
@export var max_health: float = 20.0

enum State { IDLE, TRIGGERED }
var current_state: State = State.IDLE

var current_health: float
var has_triggered: bool = false

@onready var detection_area = $DetectionArea
@onready var attack_area = $AttackArea
var attack_hitbox: CollisionShape2D

var attack_timer: float = 0.0

func _ready():
	current_health = max_health
	
	if detection_area:
		var shape = detection_area.get_node("CollisionShape2D")
		if shape and shape.shape is CircleShape2D:
			(shape.shape as CircleShape2D).radius = trigger_radius
			
		detection_area.body_entered.connect(_on_detection_body_entered)
		detection_area.body_exited.connect(_on_detection_body_exited)
	if attack_area:
		attack_area.body_entered.connect(_on_attack_body_entered)
		attack_hitbox = attack_area.get_node("CollisionShape2D")
		
	if attack_hitbox:
		attack_hitbox.disabled = true

func _process(delta: float):
	if current_state == State.TRIGGERED:
		attack_timer -= delta
		# Active frames of attack
		if attack_timer < 0.3 and attack_timer > 0.1:
			if attack_hitbox:
				attack_hitbox.disabled = false
		else:
			if attack_hitbox:
				attack_hitbox.disabled = true
				
		if attack_timer <= 0:
			current_state = State.IDLE
			if attack_hitbox:
				attack_hitbox.disabled = true

func _on_detection_body_entered(body: Node2D):
	if body.is_in_group("player") and current_state == State.IDLE and not has_triggered:
		current_state = State.TRIGGERED
		has_triggered = true
		attack_timer = 0.8 # Total attack animation duration

func _on_detection_body_exited(body: Node2D):
	if body.is_in_group("player"):
		has_triggered = false

func _on_attack_body_entered(body: Node2D):
	if body.has_method("take_damage"):
		body.take_damage(attack_damage)

func take_damage(amount: float):
	current_health -= amount
	if current_health <= 0:
		emit_signal("soul_released")
		queue_free()
