extends Node2D

@export var room_size = Vector2i(256, 256)
@onready var player = $Player

var rooms = {}

func _ready():
	pass

func _process(delta):
	var player_room = Vector2i(player.position) / room_size
	for x in range(player_room.x - 1, player_room.x + 2):
		for y in range(player_room.y - 1, player_room.y + 2):
			if Vector2i(x, y) not in rooms:
				add_room(x, y)

func add_room(x: int, y: int):
	print("Generating room x=", x, " y=", y)
	var room = preload("res://scenes/room.tscn").instantiate()
	room.position = Vector2i(x, y) * room_size
	rooms[Vector2i(x, y)] = room
	add_child(room)
