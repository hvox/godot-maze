extends Node2D

@export var room_size = Vector2i(64, 64)
@onready var player = $Player
var player_room: Vector2i = Vector2i(0, 0)
var debug_rect = []
var debug = false

var rooms = {}

func _ready():
	for x in range(-1, 17):
		add_room(x, -1)
		add_room(x, 16)
	for y in range(-1, 17):
		add_room(-1, y)
		add_room(16, y)

func _draw():
	if not debug:
		return
	for rect in debug_rect:
		var x1 = rect[0]
		var y1 = rect[1]
		var x2 = rect[2]
		var y2 = rect[3]
		draw_rect(Rect2(Vector2(x1, y1) * Vector2(room_size), Vector2(x2-x1,y2-y1) * Vector2(room_size)),
			Color.GREEN, false, 1)
	draw_rect(Rect2(player_room * room_size, room_size), Color.WHITE, false, 1)

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		debug = not debug
	player_room = Vector2i(player.position) / room_size
	var new_rooms = []
	var FOW = 1
	for x in range(player_room.x - FOW, player_room.x + FOW + 1):
		for y in range(player_room.y - FOW, player_room.y + FOW + 1):
			if Vector2i(x, y) not in rooms:
				new_rooms.append([x, y])
	for room in new_rooms:
		add_room(room[0], room[1])
	debug_rect.clear()
	for passage in get_passages(player_room[0], player_room[1]):
		# debug_rect.append([passage[0] - 0.25, passage[1] - 0.5, passage[0] + .5, passage[1]+.25])
		pass
	queue_redraw()

func add_room(x: int, y: int):
	print("Generating room x=", x, " y=", y)
	var room = preload("res://scenes/room.tscn").instantiate()
	room.position = Vector2i(x, y) * room_size
	room.z_index -= 1
	for passage in get_passages(x, y):
		if x == passage[0] and passage[1] == y + 0.5:
			room.left_wall = false
		elif x + .5 == passage[0] and y + 1 == passage[1]:
			room.down_wall = false
	room.room_size = room_size.x / 16
	room.filled = not (0 <= x and x < 16 and 0 <= y and y < 16)
	rooms[Vector2i(x, y)] = room
	add_child(room)

func get_passages(x: int, y: int, x1: int = 0, y1: int = 0, x2: int = 16, y2: int = 16, passages = []):
	debug_rect.append([x1, y1, x2, y2])
	if x2 - x1 == 1 and y2 - y1 == 1:
		return passages
	if x2 - x1 > y2 - y1:
		var mid = random([x1, y1, x2, y2, 5], x1 + 1, x2)
		var passage = random([x1, y1, x2, y2], y1, y2) + .5
		passages.append([mid, passage])
		if x < mid:
			return get_passages(x, y, x1, y1, mid, y2, passages)
		else:
			return get_passages(x, y, mid, y1, x2, y2, passages)
	else:
		var mid = random([x1, y1, x2, y2, 4], y1 + 1, y2)
		var passage = random([x1, y1, x2, y2], x1, x2) + .5
		passages.append([passage, mid])
		if y < mid:
			return get_passages(x, y, x1, y1, x2, mid, passages)
		else:
			return get_passages(x, y, x1, mid, x2, y2, passages)


func random(seed, min: int, sup: int) -> int:
	return hash(seed) % (sup - min) + min
