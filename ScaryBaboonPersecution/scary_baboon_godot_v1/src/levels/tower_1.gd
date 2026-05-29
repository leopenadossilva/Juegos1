class_name Tower1
extends Node2D

const PLATFORM_COLOR := Color(0.72, 0.55, 0.40, 1.0)
const SPAWN_POSITION := Vector2(0, -64)
const TILE_SIZE := 64.0
const TEX_SIZE := 70.0
const TEX_SCALE_Y := TILE_SIZE / TEX_SIZE
# Player dies if they fall below this Y. Sits well under the floor (y=0..32).
const FALL_DEATH_Y := 400.0
const DEATH_FX_DELAY_BEFORE_UI := 0.55

const GRASS_TILE: Texture2D = preload("res://assets/tiles/grass/grassHalfMid.png")

const PLATFORMS: Array[Rect2] = [
	Rect2(-500, 0, 540, 32),
	Rect2(180, 0, 320, 32),
	Rect2(-532, -1500, 32, 1500),
	Rect2(500, -1500, 32, 1500),
	Rect2(-300, -100, 200, 16),
	Rect2(-100, -200, 250, 16),
	Rect2(150, -300, 250, 16),
	Rect2(200, -400, 250, 16),
	Rect2(0, -500, 250, 16),
	Rect2(-250, -600, 250, 16),
	Rect2(-450, -700, 250, 16),
	Rect2(-300, -800, 250, 16),
	Rect2(-50, -900, 250, 16),
	Rect2(200, -1000, 250, 16),
	Rect2(50, -1100, 250, 16),
	Rect2(-150, -1200, 250, 16),
	Rect2(-350, -1300, 250, 16),
	Rect2(-300, -1400, 400, 16),
]

@onready var player: Player = $Player as Player
@onready var goal: Area2D = $Goal as Area2D

var _is_dead: bool = false
var _game_over_layer: CanvasLayer
var _restart_button: Button

func _ready() -> void:
	for rect: Rect2 in PLATFORMS:
		_add_platform(rect)
	goal.body_entered.connect(_on_goal_body_entered)
	_build_game_over_ui()

func _physics_process(_delta: float) -> void:
	if not _is_dead and player.global_position.y > FALL_DEATH_Y:
		_kill_player()

func respawn_player() -> void:
	player.position = SPAWN_POSITION
	player.velocity = Vector2.ZERO

func _on_goal_body_entered(body: Node2D) -> void:
	if body == player:
		print("[Tower1] Goal reached — respawning player.")
		respawn_player()

func _kill_player() -> void:
	_is_dead = true
	_spawn_death_particles(player.global_position)
	player.hide()
	player.set_physics_process(false)
	player.set_process(false)
	player.set_process_input(false)
	player.set_process_unhandled_input(false)
	await get_tree().create_timer(DEATH_FX_DELAY_BEFORE_UI).timeout
	_show_game_over()

func _spawn_death_particles(pos: Vector2) -> void:
	var particles := CPUParticles2D.new()
	particles.global_position = pos
	particles.z_index = 100
	particles.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	particles.one_shot = true
	particles.amount = 90
	particles.lifetime = 1.1
	particles.explosiveness = 1.0
	particles.direction = Vector2(0, -1)
	particles.spread = 180.0
	particles.gravity = Vector2(0, 900)
	particles.initial_velocity_min = 250.0
	particles.initial_velocity_max = 600.0
	particles.scale_amount_min = 5.0
	particles.scale_amount_max = 11.0
	particles.angular_velocity_min = -180.0
	particles.angular_velocity_max = 180.0

	var gradient := Gradient.new()
	gradient.offsets = PackedFloat32Array([0.0, 0.25, 0.6, 1.0])
	gradient.colors = PackedColorArray([
		Color(1.0, 0.95, 0.55, 1.0),  # bright yellow core
		Color(1.0, 0.55, 0.10, 1.0),  # orange
		Color(0.85, 0.15, 0.05, 1.0), # red
		Color(0.25, 0.04, 0.02, 0.0), # fade to dark, transparent
	])
	particles.color_ramp = gradient

	add_child(particles)
	particles.emitting = true

	var cleanup_timer := get_tree().create_timer(particles.lifetime + 0.5)
	cleanup_timer.timeout.connect(particles.queue_free)

func _build_game_over_ui() -> void:
	_game_over_layer = CanvasLayer.new()
	_game_over_layer.layer = 10
	_game_over_layer.visible = false
	add_child(_game_over_layer)

	var dim := ColorRect.new()
	dim.color = Color(0, 0, 0, 0.65)
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	dim.mouse_filter = Control.MOUSE_FILTER_STOP
	_game_over_layer.add_child(dim)

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_game_over_layer.add_child(center)

	var vbox := VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 36)
	center.add_child(vbox)

	var label := Label.new()
	label.text = "GAME OVER"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 96)
	label.add_theme_color_override("font_color", Color(1.0, 0.35, 0.15))
	label.add_theme_color_override("font_outline_color", Color(0, 0, 0))
	label.add_theme_constant_override("outline_size", 8)
	vbox.add_child(label)

	_restart_button = Button.new()
	_restart_button.text = "Restart"
	_restart_button.custom_minimum_size = Vector2(280, 80)
	_restart_button.add_theme_font_size_override("font_size", 36)
	_restart_button.pressed.connect(_on_restart_pressed)
	vbox.add_child(_restart_button)

func _show_game_over() -> void:
	_game_over_layer.visible = true
	if _restart_button:
		_restart_button.grab_focus()

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()

func _add_platform(rect: Rect2) -> void:
	var body := StaticBody2D.new()
	body.position = rect.position + rect.size / 2.0

	var shape := RectangleShape2D.new()
	shape.size = rect.size
	var collision := CollisionShape2D.new()
	collision.shape = shape
	body.add_child(collision)

	if rect.size.x >= rect.size.y:
		_add_horizontal_tiles(body, rect.size)
	else:
		_add_polygon_visual(body, rect.size)

	add_child(body)

func _add_horizontal_tiles(body: StaticBody2D, size: Vector2) -> void:
	var n := maxi(1, roundi(size.x / TILE_SIZE))
	var tile_width := size.x / float(n)
	var scale_x := tile_width / TEX_SIZE
	for i in n:
		var sprite := Sprite2D.new()
		sprite.texture = GRASS_TILE
		sprite.scale = Vector2(scale_x, TEX_SCALE_Y)
		sprite.position = Vector2(
			-size.x / 2.0 + (i + 0.5) * tile_width,
			-size.y / 2.0,
		)
		body.add_child(sprite)

func _add_polygon_visual(body: StaticBody2D, size: Vector2) -> void:
	var hw := size.x / 2.0
	var hh := size.y / 2.0
	var poly := Polygon2D.new()
	poly.polygon = PackedVector2Array([
		Vector2(-hw, -hh),
		Vector2(hw, -hh),
		Vector2(hw, hh),
		Vector2(-hw, hh),
	])
	poly.color = PLATFORM_COLOR
	body.add_child(poly)
