extends Node2D

# Atlas coordinates into tileset_main.tres (tilemap_packed.png, 17x8 grid).
# These are first-pass guesses — open the TileSet editor and swap any that
# don't match what you want. Source ID 0 is the only atlas source.
const SOURCE_ID := 0

const GRASS         := Vector2i(0, 0)
const GRASS_TUFT    := Vector2i(1, 0)
const WATER         := Vector2i(5, 0)
const PATH          := Vector2i(3, 1)
const TREE          := Vector2i(13, 0)
const HOUSE_WALL    := Vector2i(0, 3)
const HOUSE_ROOF    := Vector2i(2, 3)
const HOUSE_DOOR    := Vector2i(1, 5)

const WORLD_W := 30
const WORLD_H := 20

@onready var ground: TileMapLayer = $Ground
@onready var objects: TileMapLayer = $Objects

func _ready() -> void:
	_paint_ground()
	_paint_objects()

func _paint_ground() -> void:
	for y in WORLD_H:
		for x in WORLD_W:
			var tile := GRASS_TUFT if (x * 7 + y * 13) % 11 == 0 else GRASS
			ground.set_cell(Vector2i(x, y), SOURCE_ID, tile)

	# Pond in the upper-left area.
	for y in range(3, 7):
		for x in range(4, 9):
			ground.set_cell(Vector2i(x, y), SOURCE_ID, WATER)

	# Horizontal dirt path across the middle.
	for x in WORLD_W:
		ground.set_cell(Vector2i(x, 12), SOURCE_ID, PATH)

func _paint_objects() -> void:
	const TREES := [
		Vector2i(15, 3), Vector2i(20, 4), Vector2i(22, 6),
		Vector2i(18, 8), Vector2i(25, 10), Vector2i(2, 15),
		Vector2i(6, 17), Vector2i(11, 16),
	]
	for pos in TREES:
		objects.set_cell(pos, SOURCE_ID, TREE)

	# Small 3x2 house with a door in the middle bottom.
	var hx := 18
	var hy := 14
	for dy in 2:
		for dx in 3:
			var tile := HOUSE_ROOF if dy == 0 else HOUSE_WALL
			objects.set_cell(Vector2i(hx + dx, hy + dy), SOURCE_ID, tile)
	objects.set_cell(Vector2i(hx + 1, hy + 1), SOURCE_ID, HOUSE_DOOR)
