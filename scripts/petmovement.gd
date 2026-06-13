extends CharacterBody2D


const SPEED := 60.0 # float
var direction := 1 #int
var is_dragging := false # boolean
var initial_posit := Vector2.ZERO # idk tbh

@onready var collider = $CollisionShape2D
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	_fall(delta)
	_walk()
	

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
	position.x += direction * SPEED * delta

func _click_and_drag(event: InputEvent) -> void:
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		#if event.is_pressed():
			
		#elif event.is_released():
			

	move_and_slide()
