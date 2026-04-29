extends Area2D
class_name GloomWisp

@export var speed: float = 30.0
var target: Node2D = null

func _ready():
	area_entered.connect(_on_area_entered)

func _physics_process(delta: float):
	if not target:
		var players = get_tree().get_nodes_in_group("player")
		for player in players:
			if player.has_node("Hana"):
				target = player.get_node("Hana")
				break
				
	if target:
		global_position = global_position.move_toward(target.global_position, speed * delta)

func _on_area_entered(area: Area2D):
	if area.name == "HanaLightRadius":
		var hana = area.get_parent()
		if hana and hana.has_method("reduce_light"):
			hana.reduce_light(0.20)
			queue_free()
