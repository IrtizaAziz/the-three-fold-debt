extends Area2D
class_name SpiritArrow

@export var speed: float = 300.0
@export var damage: float = 20.0

var direction: float = -1.0
var is_reversed: bool = false
var archer_owner: Node = null

@onready var lifetime_timer = $LifetimeTimer

func _ready():
	body_entered.connect(_on_body_entered)
	if lifetime_timer:
		lifetime_timer.timeout.connect(func(): queue_free())

func _physics_process(delta: float):
	position.x += direction * speed * delta

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		if is_reversed:
			# Reversed arrow touching the player again — just disappear (no double damage)
			queue_free()
			return
		if body.has_method("try_parry_incoming"):
			var result = body.try_parry_incoming(damage, self)
			if not result:
				# Not parried — deal full damage and destroy arrow
				if body.has_method("take_damage"):
					body.take_damage(damage)
				queue_free()
			# If parried, reverse() was already called by try_parry_incoming — arrow continues flying
		else:
			if body.has_method("take_damage"):
				body.take_damage(damage)
			queue_free()
	elif body == archer_owner:
		if is_reversed and archer_owner.has_method("take_damage"):
			archer_owner.take_damage(25.0)
		queue_free()
	else:
		# Any other solid
		queue_free()

func reverse():
	direction *= -1.0
	is_reversed = true
