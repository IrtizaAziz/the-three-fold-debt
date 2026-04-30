extends Node2D

# One-shot guards — prevent dialogue from re-firing
var hana_spawned := false
var kaito_triggered := false
var climax_triggered := false

func _ready() -> void:
	# Auto-fire the opening dialogue 1 second after scene loads
	await get_tree().create_timer(1.0).timeout
	$HUD.show_dialogue("The mud is cold. The bamboo is silent. Something is wrong with the sky.")
	await get_tree().create_timer(4.0).timeout
	$HUD.hide_dialogue()

func _on_hana_spawn_trigger_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player") or hana_spawned:
		return
	hana_spawned = true
	$HUD.show_gloom_meter()
	$HUD.show_dialogue("Ren... I found you. Don't let go of the lantern. Please.")
	await get_tree().create_timer(4.0).timeout
	$HUD.hide_dialogue()

func _on_dialogue_trigger_first_enemy_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	$HUD.show_dialogue("They're still here. The soldiers who killed us. Their grudge won't let them rest.")
	await get_tree().create_timer(4.0).timeout
	$HUD.hide_dialogue()

func _on_dialogue_trigger_corridor_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	$HUD.show_dialogue("Stay close. The Gloom feeds on loneliness — it always has.")
	await get_tree().create_timer(4.0).timeout
	$HUD.hide_dialogue()

func _on_dialogue_trigger_wisps_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	$HUD.show_dialogue("Hana — hold on! Don't let them snuff you out!")
	await get_tree().create_timer(3.0).timeout
	$HUD.hide_dialogue()

func _on_kaito_memory_trigger_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player") or kaito_triggered:
		return
	kaito_triggered = true
	$HUD.show_dialogue("...Kaito. He died right here. Right on this ground.")
	await get_tree().create_timer(2.0).timeout
	$HUD.show_dialogue("Move, little brother. Grieve later.")
	await get_tree().create_timer(4.0).timeout
	$HUD.hide_dialogue()

func _on_gloom_climax_trigger_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player") or climax_triggered:
		return
	climax_triggered = true
	$HUD.show_dialogue("It knows we're here. REN — RUN!")

func _on_level_end_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_tree().change_scene_to_file("res://Scenes/Level_2.tscn")

func _on_player_died() -> void:
	get_tree().reload_current_scene()
