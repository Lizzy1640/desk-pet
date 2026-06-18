extends Node2D

var desktop_width = 0  # x axis
var desktop_height = 0  # y axis
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# desktop bounderies
	var size: Vector2i = DisplayServer.screen_get_size()
	desktop_width = size.x
	desktop_height = size.y
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
