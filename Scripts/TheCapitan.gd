extends CharacterBody2D
class_name TheCapitan

@export var max_health: float = 300.0
@export var attack_damage: float = 25.0
@export var roar_damage_per_second: float = 5.0
@export var phase2_speed_multiplier: float = 1.2
@export var smash_windup: float = 1.2
@export var sweep_duration: float = 0.8
@export var ash_hazard_scene: PackedScene  # Drag AshHazard.tscn here in the inspector

signal boss_phase_changed(phase: int)
signal boss_defeated

var current_health: float
var current_phase: int = 1
# Start at -1 so first _next_attack() call increments to 0 → SMASH (correct per spec)
var attack_cycle: int = -1

# Phase 2 timing — divides windup/sweep by phase2_speed_multiplier on transition
var current_smash_windup: float
var current_sweep_duration: float
var is_dead: bool = false

@onready var anim_player = $AnimationPlayer
@onready var smash_hitbox = $SmashHitbox
@onready var sweep_hitbox = $SweepHitbox
@onready var roar_ash_spawner = $RoarAshSpawner

func _ready():
	current_health = max_health
	current_smash_windup = smash_windup
	current_sweep_duration = sweep_duration

	if smash_hitbox:
		var col = smash_hitbox.get_node("CollisionShape2D")
		if col: col.disabled = true
		smash_hitbox.body_entered.connect(_on_smash_hitbox_body_entered)

	if sweep_hitbox:
		var col = sweep_hitbox.get_node("CollisionShape2D")
		if col: col.disabled = true
		sweep_hitbox.body_entered.connect(_on_sweep_hitbox_body_entered)

	if roar_ash_spawner:
		roar_ash_spawner.timeout.connect(_spawn_ash_hazard)

	if anim_player:
		anim_player.animation_finished.connect(_on_animation_finished)

	# Begin the attack loop — first call goes to cycle 0 = SMASH
	call_deferred("_next_attack")

func _next_attack():
	if is_dead:
		return
	attack_cycle = (attack_cycle + 1) % 4
	match attack_cycle:
		0, 2: _do_smash()
		1:    _do_sweep()
		3:    _do_roar()

func _do_smash():
	if is_dead: return
	if anim_player:
		anim_player.play("smash")

	# Wait for windup — faster in Phase 2
	await get_tree().create_timer(current_smash_windup).timeout
	if is_dead: return

	if smash_hitbox:
		var col = smash_hitbox.get_node("CollisionShape2D")
		if col: col.disabled = false

		await get_tree().create_timer(0.3).timeout
		if is_dead: return

		if col: col.disabled = true

	await get_tree().create_timer(0.5).timeout
	_next_attack()

func _do_sweep():
	if is_dead: return
	if anim_player:
		anim_player.play("sweep")

	if sweep_hitbox:
		var col = sweep_hitbox.get_node("CollisionShape2D")
		if col: col.disabled = false

		# Sweep duration — faster in Phase 2
		await get_tree().create_timer(current_sweep_duration).timeout
		if is_dead: return

		if col: col.disabled = true

	await get_tree().create_timer(0.3).timeout
	_next_attack()

func _do_roar():
	if is_dead: return
	if anim_player:
		anim_player.play("roar")

	# Spawn ash for 3 seconds at 0.3s intervals
	if roar_ash_spawner:
		roar_ash_spawner.start(0.3)

	await get_tree().create_timer(3.0).timeout
	if is_dead: return

	if roar_ash_spawner:
		roar_ash_spawner.stop()

	await get_tree().create_timer(0.5).timeout
	_next_attack()

func _spawn_ash_hazard():
	# Uses AshHazard.tscn which has its own _process() for falling.
	# No process_frame.connect() here — avoids the accumulation bug.
	if not ash_hazard_scene:
		return
	var hazard = ash_hazard_scene.instantiate()
	hazard.chip_damage = roar_damage_per_second * 0.3

	# Spawn at random X across arena width, above the screen
	hazard.global_position = Vector2(
		global_position.x + randf_range(-400, 0),
		global_position.y - 400
	)
	get_parent().add_child(hazard)

func _on_smash_hitbox_body_entered(body: Node2D):
	# Smash hit — no parry, direct damage
	if body.is_in_group("player") and body.has_method("take_damage"):
		body.take_damage(attack_damage)

func _on_sweep_hitbox_body_entered(body: Node2D):
	# Sweep can be parried — check before dealing damage
	if body.is_in_group("player"):
		var parried = false
		if body.has_method("try_parry_incoming"):
			parried = body.try_parry_incoming(attack_damage, self)
		if not parried and body.has_method("take_damage"):
			body.take_damage(attack_damage)

func _on_animation_finished(_anim_name: String):
	pass # Attack sequencing handled by awaits above

func take_damage(amount: float):
	if is_dead:
		return
	current_health -= amount

	# Phase 2 transition at 50% HP
	if current_health <= max_health * 0.5 and current_phase == 1:
		current_phase = 2
		emit_signal("boss_phase_changed", 2)
		# Speed up future attack timings by the multiplier
		current_smash_windup = smash_windup / phase2_speed_multiplier
		current_sweep_duration = sweep_duration / phase2_speed_multiplier

	if current_health <= 0:
		_on_defeated()

func _on_defeated():
	is_dead = true
	emit_signal("boss_defeated")

	# Disable all hitboxes immediately
	if smash_hitbox:
		var col = smash_hitbox.get_node("CollisionShape2D")
		if col: col.set_deferred("disabled", true)

	if sweep_hitbox:
		var col = sweep_hitbox.get_node("CollisionShape2D")
		if col: col.set_deferred("disabled", true)

	if roar_ash_spawner:
		roar_ash_spawner.stop()

	if anim_player and anim_player.has_animation("death"):
		anim_player.play("death")
		await anim_player.animation_finished

	queue_free()
