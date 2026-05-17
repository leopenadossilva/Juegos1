class_name Tower1
extends Node2D

const PLATFORM_COLOR := Color(0.42, 0.42, 0.5, 1.0)
const SPAWN_POSITION := Vector2(0, -64)

const PLATFORMS: Array[Rect2] = [
	Rect2(-320, 0, 640, 32),
	Rect2(-352, -2192, 32, 2192),
	Rect2(320, -2192, 32, 2192),
	Rect2(-280, -300, 100, 16),
	Rect2(100, -600, 120, 16),
	Rect2(-280, -900, 100, 16),
	Rect2(180, -1200, 100, 16),
	Rect2(-50, -1500, 100, 16),
	Rect2(-280, -1800, 200, 16),
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

	var hw := rect.size.x / 2.0
	var hh := rect.size.y / 2.0
	var poly := Polygon2D.new()
	poly.polygon = PackedVector2Array([
		Vector2(-hw, -hh),
		Vector2(hw, -hh),
		Vector2(hw, hh),
		Vector2(-hw, hh),
	])
	poly.color = PLATFORM_COLOR
	body.add_child(poly)

	add_child(body)
