class_name Tower1
extends Node2D

const PLATFORM_COLOR := Color(0.72, 0.55, 0.40, 1.0)
const SPAWN_POSITION := Vector2(0, -64)
const TILE_SIZE := 64.0
const TEX_SIZE := 70.0
const TEX_SCALE_Y := TILE_SIZE / TEX_SIZE

const GRASS_TILE: Texture2D = preload("res://assets/tiles/grass/grassHalfMid.png")

const PLATFORMS: Array[Rect2] = [
	Rect2(-500, 0, 1000, 32),
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

func _ready() -> void:
	for rect: Rect2 in PLATFORMS:
		_add_platform(rect)
	goal.body_entered.connect(_on_goal_body_entered)

func respawn_player() -> void:
	player.position = SPAWN_POSITION
	player.velocity = Vector2.ZERO

func _on_goal_body_entered(body: Node2D) -> void:
	if body == player:
		print("[Tower1] Goal reached — respawning player.")
		respawn_player()

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
