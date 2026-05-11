extends CanvasLayer
class_name HUD

@onready var health_bar: ProgressBar = $HealthBar
@onready var gloom_bar: ProgressBar = $GloomMeter

func _ready():
	# Wait one frame to ensure Player and Hana are fully loaded into the scene tree
	await get_tree().process_frame
	
	# Automatically find the player using the "player" group
	var player = get_tree().get_first_node_in_group("player")
	
	if player:
		# Set up Health Bar
		if health_bar:
			health_bar.max_value = player.max_health
			health_bar.value = player.current_health
			player.health_changed.connect(_on_health_changed)
			
		# Find Hana (she is a child of the Player node)
		var hana = player.get_node_or_null("Hana")
		if hana and gloom_bar:
			gloom_bar.max_value = hana.max_gloom
			gloom_bar.value = hana.current_gloom
			hana.gloom_changed.connect(_on_gloom_changed)
	else:
		push_warning("HUD could not find a node in the 'player' group!")

func _on_health_changed(new_health: float):
	if health_bar:
		# Animate the health bar for juiciness
		var tween = create_tween()
		tween.tween_property(health_bar, "value", new_health, 0.2).set_trans(Tween.TRANS_SINE)

func _on_gloom_changed(new_gloom: float):
	if gloom_bar:
		# Animate the gloom bar
		var tween = create_tween()
		tween.tween_property(gloom_bar, "value", new_gloom, 0.1).set_trans(Tween.TRANS_LINEAR)

func show_gloom_meter() -> void:
	$GloomMeter.visible = true

func show_health_bar() -> void:
	$HealthBar.visible = true

func show_dialogue(text: String) -> void:
	$DialogueBox/DialogueLabel.text = text
	$DialogueBox.visible = true

func hide_dialogue() -> void:
	$DialogueBox.visible = false
