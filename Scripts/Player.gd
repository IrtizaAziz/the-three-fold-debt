extends CharacterBody2D
class_name Player

signal health_changed(new_health: float)
signal player_died
signal kaito_echo_triggered
signal kaito_phantom_strike
signal hana_flare

@export var combo_window: float = 0.4
@export var phantom_strike_damage: float = 40.0
@export var hitstop_duration: float = 0.08
@export var parry_window: float = 0.15
@export var parry_block_reduction: float = 0.5

@export var speed: float = 200.0
@export var acceleration: float = 800.0
@export var friction: float = 1000.0
@export var jump_force: float = -400.0
@export var gravity: float = 980.0
@export var fall_gravity_multiplier: float = 1.5
@export var roll_speed: float = 350.0
@export var roll_duration: float = 0.4
@export var max_health: float = 100.0

enum State { IDLE, RUN, JUMP, FALL, ROLL }
var current_state: State = State.IDLE

var current_health: float
var is_rolling: bool = false
var roll_timer: float = 0.0
var roll_direction: float = 1.0

# Kaito's "Vengeful Echo"
var kaito_timer: float = 0.0
var kaito_active: bool = false
var kaito_cooldown: bool = false

var combo_step: int = 0
var combo_timer: float = 0.0
var is_parrying: bool = false
var parry_timer: float = 0.0
# hitstop is handled via real-time create_timer in phantom_strike(); not a per-frame variable

func _ready():
	add_to_group("player")
	current_health = max_health
	call_deferred("emit_signal", "health_changed", current_health)

func _physics_process(delta: float):
	# Process Kaito Timer — only deactivates the window; cooldown resets via heal() only
	if kaito_timer > 0:
		kaito_timer -= delta
		if kaito_timer <= 0:
			kaito_active = false  # Window closed; echo was not used

	if combo_timer > 0:
		combo_timer -= delta
		if combo_timer <= 0 and combo_step > 0:
			combo_step = 0
			
	if parry_timer > 0:
		parry_timer -= delta
		if parry_timer <= 0:
			is_parrying = false

	match current_state:
		State.IDLE:
			state_idle(delta)
		State.RUN:
			state_run(delta)
		State.JUMP:
			state_jump(delta)
		State.FALL:
			state_fall(delta)
		State.ROLL:
			state_roll(delta)
			
	move_and_slide()

func get_input_dir() -> float:
	return Input.get_axis("ui_left", "ui_right")

func apply_gravity(delta: float, multiplier: float = 1.0):
	if not is_on_floor():
		velocity.y += gravity * multiplier * delta

func apply_horizontal_movement(direction: float, delta: float):
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * speed, acceleration * delta)
		roll_direction = sign(direction)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)

func state_idle(delta: float):
	apply_gravity(delta)
	apply_horizontal_movement(0, delta)
	
	var dir = get_input_dir()
	if dir != 0:
		current_state = State.RUN
	elif Input.is_action_just_pressed("ui_accept") and is_on_floor():
		jump()
	elif (Input.is_action_just_pressed("roll") or Input.is_key_pressed(KEY_SHIFT)) and is_on_floor():
		start_roll()
	elif not is_on_floor():
		current_state = State.FALL

	if Input.is_key_pressed(KEY_C):
		start_parry()
		
	if Input.is_key_pressed(KEY_Z) and Input.is_action_pressed("ui_up"):
		upward_slash()
	elif Input.is_key_pressed(KEY_Z):
		spectral_edge()
	elif Input.is_key_pressed(KEY_X):
		phantom_strike()

func state_run(delta: float):
	apply_gravity(delta)
	var dir = get_input_dir()
	apply_horizontal_movement(dir, delta)
	
	if dir == 0 and velocity.x == 0:
		current_state = State.IDLE
	elif Input.is_action_just_pressed("ui_accept") and is_on_floor():
		jump()
	elif (Input.is_action_just_pressed("roll") or Input.is_key_pressed(KEY_SHIFT)) and is_on_floor():
		start_roll()
	elif not is_on_floor():
		current_state = State.FALL

	if Input.is_key_pressed(KEY_C):
		start_parry()
		
	if Input.is_key_pressed(KEY_Z) and Input.is_action_pressed("ui_up"):
		upward_slash()
	elif Input.is_key_pressed(KEY_Z):
		spectral_edge()
	elif Input.is_key_pressed(KEY_X):
		phantom_strike()

func state_jump(delta: float):
	apply_gravity(delta)
	var dir = get_input_dir()
	apply_horizontal_movement(dir, delta)
	
	if velocity.y >= 0:
		current_state = State.FALL
	elif Input.is_action_just_pressed("roll") or Input.is_key_pressed(KEY_SHIFT):
		start_roll()

func state_fall(delta: float):
	apply_gravity(delta, fall_gravity_multiplier)
	var dir = get_input_dir()
	apply_horizontal_movement(dir, delta)
	
	if is_on_floor():
		current_state = State.IDLE
	elif Input.is_action_just_pressed("roll") or Input.is_key_pressed(KEY_SHIFT):
		start_roll()

func jump():
	velocity.y = jump_force
	current_state = State.JUMP

func start_roll():
	current_state = State.ROLL
	is_rolling = true
	roll_timer = roll_duration
	velocity.y = 0
	velocity.x = roll_direction * roll_speed

func state_roll(delta: float):
	roll_timer -= delta
	velocity.x = roll_direction * roll_speed
	apply_gravity(delta)
	
	if roll_timer <= 0:
		is_rolling = false
		if is_on_floor():
			current_state = State.IDLE if get_input_dir() == 0 else State.RUN
		else:
			current_state = State.FALL

func take_damage(amount: float):
	if is_rolling:
		return # Negate damage during roll (iframes)
		
	if kaito_active:
		kaito_active = false
		emit_signal("kaito_echo_triggered")
		return # Damage blocked by Kaito
		
	current_health -= amount
	emit_signal("health_changed", current_health)
	
	if current_health <= 0:
		emit_signal("player_died")
	
	# Monitor Ren's health for Kaito trigger
	if current_health > 0 and current_health <= (max_health * 0.25) and not kaito_cooldown:
		kaito_active = true
		kaito_timer = 2.0
		kaito_cooldown = true

func heal(amount: float):
	current_health = min(current_health + amount, max_health)
	emit_signal("health_changed", current_health)
	
	# If health rises above 25%, reset Kaito cooldown so it can trigger again
	if current_health > (max_health * 0.25):
		kaito_cooldown = false

# --- Kaito's Active Abilities ---

var attack_debounce: float = 0.0 # Prevents spamming from continuous key presses

func spectral_edge():
	if attack_debounce > 0: return
	attack_debounce = 0.2 # small delay between combo hits
	
	var reach = 40.0
	if combo_step == 1: reach = 60.0
	elif combo_step == 2: reach = 80.0
	
	combo_step += 1
	if combo_step > 2: combo_step = 0
	combo_timer = combo_window
	
	var hitbox = Area2D.new()
	hitbox.name = "SpectralEdgeHitbox" + str(combo_step)
	
	var shape = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = Vector2(reach, 40)
	shape.shape = rect
	hitbox.add_child(shape)
	
	hitbox.position = Vector2(reach / 2.0 * roll_direction, 0)
	add_child(hitbox)
	
	hitbox.body_entered.connect(func(body):
		if body != self and body.has_method("take_damage"):
			body.take_damage(15.0)
	)
	
	get_tree().create_timer(0.15).timeout.connect(func(): hitbox.queue_free())

func upward_slash():
	if attack_debounce > 0: return
	attack_debounce = 0.3
	
	var hitbox = Area2D.new()
	hitbox.name = "UpwardSlashHitbox"
	
	var shape = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = Vector2(60, 40)
	shape.shape = rect
	hitbox.add_child(shape)
	
	hitbox.position = Vector2(0, -50)
	add_child(hitbox)
	
	hitbox.body_entered.connect(func(body):
		if body != self and body.has_method("take_damage"):
			body.take_damage(20.0)
	)
	
	get_tree().create_timer(0.2).timeout.connect(func(): hitbox.queue_free())

func phantom_strike():
	if attack_debounce > 0: return
	attack_debounce = 0.5
	
	var hitbox = Area2D.new()
	hitbox.name = "PhantomStrikeHitbox"
	
	var shape = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = Vector2(120, 80)
	shape.shape = rect
	hitbox.add_child(shape)
	
	hitbox.position = Vector2(60 * roll_direction, 0)
	add_child(hitbox)
	
	var hitstop_applied := false  # Guard: only freeze once per swing
	
	hitbox.body_entered.connect(func(body):
		if body != self:
			if body.has_method("take_damage"):
				body.take_damage(phantom_strike_damage, true)
				if not hitstop_applied:
					hitstop_applied = true
					Engine.time_scale = 0
					# Use real-time timer (true) so it fires even when time_scale=0
					get_tree().create_timer(hitstop_duration, false, false, true).timeout.connect(
						func(): Engine.time_scale = 1.0
					)
					emit_signal("kaito_phantom_strike")
			if body.has_method("add_soul"):
				body.add_soul()
				body.add_soul()
				body.add_soul()
	)
	
	get_tree().create_timer(0.3).timeout.connect(func(): hitbox.queue_free())

func start_parry():
	is_parrying = true
	parry_timer = parry_window

func try_parry_incoming(damage: float, source: Node) -> bool:
	if is_parrying:
		if source.has_method("reverse"):
			source.reverse()
		if source.has_method("apply_stun"):
			source.apply_stun(1.0)
		return true
	
	if Input.is_key_pressed(KEY_C):
		take_damage(damage * parry_block_reduction)
		return true
		
	return false

# Handle attack debounce independently of physics states
func _process(delta):
	if attack_debounce > 0:
		attack_debounce -= delta
