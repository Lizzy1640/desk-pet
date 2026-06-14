extends CharacterBody2D

const SPEED := 60.0 # float
var direction := 1 #int
var is_dragging := false # boolean
var mouse_offset := Vector2.ZERO # idk tbh
var is_mouse_inside := false

@onready var collider = $CollisionShape2D
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	var size = DisplayServer.screen_get_size()
	print(size)
	DisplayServer.window_set_size(size)
	
	# get_window().mouse_passthrough = true
	# ^ lets mouse click on stuff behind game window
	# but game window gets covered by clicked on window

func _physics_process(delta: float) -> void:
	if is_dragging:
		position = get_global_mouse_position() + mouse_offset
	else:
		_fall(delta)
		#_walk()
	

func _on_mouse_entered() -> void:
	is_mouse_inside = true
	print("in")
func _on_mouse_exited() -> void:
	is_mouse_inside = false
	print("not in")

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button.index == MOUSE_BUTTON_LEFT:
		if event.is_pressed() and is_mouse_inside:
			is_dragging = true
			print("dragging")
			mouse_offset = position - get_global_mouse_position()
		else:
			is_dragging = false
			print("done dragging")
	

func _walk():
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false

func _fall(delta: float):
	# need to get the x and y velocity of mouse
	if not is_on_floor():
		velocity += get_gravity() * delta
	#position.x += direction * SPEED * delta



	move_and_slide()
