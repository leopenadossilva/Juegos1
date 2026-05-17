class_name Tower1
extends Node2D

const PLATFORM_COLOR := Color(0.42, 0.42, 0.5, 1.0)
const SPAWN_POSITION := Vector2(0, -64)

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
