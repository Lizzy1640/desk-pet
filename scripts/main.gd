extends Node

# Exports dealing with main character
@export var player_size: Vector2i = Vector2i(32, 32)
@export_node_path("Camera2D") var main_camera: NodePath
#@export var view_window: PackedScene # idk if I need this
var world_offset: = Vector2i.ZERO

@onready var _MainCamera: Camera2D = get_node(main_camera)
@onready var _MainWindow: Window = get_window()
@onready var _MainScreen: int = _MainWindow.current_screen
@onready var _MainScreenRect: Rect2i = DisplayServer.screen_get_usable_rect(_MainScreen)

func _ready() -> void:
	## MAIN WINDOW SET UP ##
	ProjectSettings.set_setting("display/window/per_pixel_transparency/allowed", true)
	# Set window settings (most can be set in project settings and should be)
	_MainWindow.borderless = true
	_MainWindow.unresizable = true
	_MainWindow.always_on_top = true
	_MainWindow.gui_embed_subwindows = false
	_MainWindow.transparent = true
	_MainWindow.transparent_bg = true
	
	# make sure min size isn't larger than the size needed
	_MainWindow.min_size = player_size
	_MainWindow.size = _MainWindow.min_size
	
	# position the world at the bottom-center of the screen
	world_offset = Vector2i(_MainScreenRect.size.x / 2, _MainScreenRect.size.y)

func _process(_delta: float) -> void:
	# update the main window's position
	_MainWindow.position = get_window_pos_from_camera()

func get_window_pos_from_camera() -> Vector2i:
	return (Vector2i(_MainCamera.global_position + _MainCamera.offset) - player_size / 2) * Vector2i(_MainCamera.zoom) + world_offset
