extends CharacterBody2D
class_name HollowedAsh

signal soul_released


@export var speed: float = 50.0
@export var chase_speed: float = 90.0
@export var gravity: float = 980.0
@export var max_health: float = 30.0
@export var attack_damage: float = 20.0
@export var attack_cooldown: float = 1.5  # Seconds before the enemy can attack again
@export var left_patrol_marker: NodePath
@export var right_patrol_marker: NodePath

var current_health: float

enum State { PATROL, CHASE, ATTACK }
var current_state: State = State.PATROL

var direction: float = 1.0
var player_target: Node2D = null

@onready var detection_area = $DetectionArea
@onready var attack_area = $AttackArea
var attack_hitbox: CollisionShape2D

var left_limit: float = 0.0
var right_limit: float = 0.0

var is_attacking: bool = false
var attack_timer: float = 0.0
var attack_cooldown_timer: float = 0.0  # Counts down between attacks

func _ready():
	current_health = max_health
	
	if not left_patrol_marker.is_empty() and not right_patrol_marker.is_empty():
		var left_node = get_node(left_patrol_marker)
		var right_node = get_node(right_patrol_marker)
		if left_node and right_node:
			left_limit = left_node.global_position.x
			right_limit = right_node.global_position.x
	
	if left_limit == 0.0 and right_limit == 0.0:
		left_limit = global_position.x - 100.0
		right_limit = global_position.x + 100.0
	
	if detection_area:
		detection_area.body_entered.connect(_on_detection_body_entered)
		detection_area.body_exited.connect(_on_detection_body_exited)
	
	if attack_area:
		attack_area.body_entered.connect(_on_attack_body_entered)
		attack_hitbox = attack_area.get_node("CollisionShape2D")
		
	if attack_hitbox:
		attack_hitbox.disabled = true

func _physics_process(delta: float):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Tick down the cooldown between attacks
	if attack_cooldown_timer > 0:
		attack_cooldown_timer -= delta
		
	match current_state:
		State.PATROL:
			state_patrol(delta)
		State.CHASE:
			state_chase(delta)
		State.ATTACK:
			state_attack(delta)
			
	move_and_slide()

func state_patrol(_delta: float):
	if player_target:
		current_state = State.CHASE
		return
		
	velocity.x = direction * speed
	if direction > 0 and global_position.x >= right_limit:
		direction = -1.0
	elif direction < 0 and global_position.x <= left_limit:
		direction = 1.0

func state_chase(_delta: float):
	if not player_target:
		current_state = State.PATROL
		return
		
	var dist = player_target.global_position.x - global_position.x
	direction = sign(dist)
	if direction == 0:
		direction = 1.0
	velocity.x = direction * chase_speed
	
	if abs(dist) < 40.0 and attack_cooldown_timer <= 0:
		start_attack()

func start_attack():
	current_state = State.ATTACK
	is_attacking = true
	attack_timer = 1.0  # 1 second attack animation duration
	attack_cooldown_timer = attack_cooldown  # Lock out further attacks during cooldown
	velocity.x = 0

func state_attack(delta: float):
	attack_timer -= delta
	
	# Enable hitbox midway through animation
	if attack_timer < 0.5 and attack_timer > 0.2:
		if attack_hitbox:
			attack_hitbox.disabled = false
	else:
		if attack_hitbox:
			attack_hitbox.disabled = true
			
	if attack_timer <= 0:
		is_attacking = false
		if attack_hitbox:
			attack_hitbox.disabled = true
		current_state = State.CHASE if player_target else State.PATROL

func _on_detection_body_entered(body: Node2D):
	if body.is_in_group("player"):
		player_target = body

func _on_detection_body_exited(body: Node2D):
	if body == player_target:
		player_target = null

func _on_attack_body_entered(body: Node2D):
	if body.has_method("take_damage"):
		body.take_damage(attack_damage)  # Uses exported variable, not hardcoded value

func take_damage(amount: float):
	current_health -= amount
	if current_health <= 0:
		emit_signal("soul_released")
		queue_free()
