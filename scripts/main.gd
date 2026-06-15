extends Node2D

@onready var camera_2d: Camera2D = $Camera2D
@onready var main_window: Window = $Window
@onready var sub_window: Window = $Window

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sub_window.world_2d = main_window.world_2d

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	camera_2d.position = get_window().position
