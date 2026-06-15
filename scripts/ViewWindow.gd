extends Window

@onready var camera_2d: Camera2D = $Camera2D

var last_position: = Vector2i.ZERO
var velocity: = Vector2i.ZERO

func _ready() -> void:
	# Set the camera anchor to top left
	# easier to work with due to window coords
	camera_2d.anchor_mode = Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT
	transient = true # a child of main window
		# closes window when clicking close button
	close_requested.connect(queue_free)

func _process(delta: float) -> void:
	velocity = position - last_position
	last_position = position
	camera_2d.position = get_camera_pos_from_window()

func get_camera_pos_from_window() -> Vector2i:
	return position + velocity
