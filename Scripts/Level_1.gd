extends Node2D

# One-shot guards — prevent dialogue from re-firing
var hana_spawned := false
var kaito_triggered := false
var climax_triggered := false

func _ready() -> void:
	_spawn_graybox_platforms()
	await get_tree().create_timer(1.0).timeout
	$HUD.show_dialogue("The mud is cold. The bamboo is silent. Something is wrong with the sky.")
	await get_tree().create_timer(4.0).timeout
	$HUD.hide_dialogue()

func _spawn_graybox_platforms() -> void:
	const LEVEL_HEIGHT: float = 5504.0
	const LEVEL_WIDTH: float = 640.0
	const PLAT_WIDTH: float = 200.0
	const PLAT_HEIGHT: float = 32.0
	const STEP_Y: float = 90.0
	const COLOR_LIGHT: Color = Color(0.4, 0.4, 0.4, 1)
	const COLOR_DARK: Color = Color(0.25, 0.25, 0.25, 1)

	var y := 5488.0
	var i := 0
	while y > 120.0:
		var x := LEVEL_WIDTH * ((LEVEL_HEIGHT - y) / LEVEL_HEIGHT)
		var plat := StaticBody2D.new()
		plat.name = "P_" + str(i)
		plat.position = Vector2(x, y)
		plat.collision_layer = 1

		var shape := CollisionShape2D.new()
		var rect := RectangleShape2D.new()
		rect.size = Vector2(PLAT_WIDTH, PLAT_HEIGHT)
		shape.shape = rect
		plat.add_child(shape)

		var viz := ColorRect.new()
		viz.offset_left = -PLAT_WIDTH / 2.0
		viz.offset_top = -PLAT_HEIGHT / 2.0
		viz.offset_right = PLAT_WIDTH / 2.0
		viz.offset_bottom = PLAT_HEIGHT / 2.0
		viz.color = COLOR_LIGHT if i % 3 == 0 else COLOR_DARK
		plat.add_child(viz)

		$Platforms.add_child(plat)
		y -= STEP_Y
		i += 1

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
	$HUD.show_health_bar()
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
	await get_tree().create_timer(4.0).timeout
	# Fire Kaito Echo signal for Atmosphere Lead's blue flash Tween
	$Player.kaito_echo_triggered.emit()
	$HUD.show_dialogue("Move, little brother. Grieve later.")
	await get_tree().create_timer(4.0).timeout
	$HUD.hide_dialogue()

func _on_gloom_climax_trigger_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player") or climax_triggered:
		return
	climax_triggered = true
	$HUD.show_dialogue("It knows we're here. REN — RUN!")

func _on_gloom_trigger_corridor_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	var hana = body.get_node_or_null("Hana")
	if hana:
		hana.gloom_rate = 20.0

func _on_kill_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.has_method("take_damage"):
		body.take_damage(body.max_health)

func _on_level_end_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_tree().change_scene_to_file("res://Scenes/Level_2.tscn")

func _on_player_died() -> void:
	call_deferred("_reload_scene")

func _reload_scene() -> void:
	get_tree().reload_current_scene()
