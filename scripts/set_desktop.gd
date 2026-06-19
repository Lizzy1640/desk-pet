extends Node2D

@onready var dock: StaticBody2D = $Barriers/Dock
@onready var right_wall: StaticBody2D = $Barriers/RightWall
@onready var left_wall: StaticBody2D = $Barriers/LeftWall
@onready var ceiling: StaticBody2D = $Barriers/Ceiling

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# desktop bounderies
	var size: Vector2i = DisplayServer.screen_get_size()
	print(size)
	dock.position.y = 0
	left_wall.position = Vector2(0, 0)
	ceiling.position = size
	right_wall.position = size
