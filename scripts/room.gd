extends Node2D

@onready var tile_map = $TileMap
const source_id = 2
var room_size: int = 4
var left_wall: bool = true
var down_wall: bool = true
var filled: bool = false


func _ready():
	tile_map.clear()
	if filled:
		for x in range(room_size): for y in range(room_size):
			tile_map.set_cell(0, Vector2i(x, y), source_id, Vector2i(4, 2))
		return
	if left_wall:
		for y in range(room_size):
			tile_map.set_cell(0, Vector2i(0, y), source_id, Vector2i(4, 2))
	if down_wall:
		for x in range(room_size):
			tile_map.set_cell(0, Vector2i(x, room_size-1), source_id, Vector2i(4, 2))
	tile_map.set_cell(0, Vector2i(0, room_size-1), source_id, Vector2i(4, 2))


func _process(delta):
	pass
