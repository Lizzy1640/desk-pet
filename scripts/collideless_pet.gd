extends CharacterBody2D

var walk_speed: float = 60.0
var run_speed: float = 120.0
var action_num: int = -1
var direction: int = 1

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var action_timer: Timer = $ActionTimer
@onready var ray_left: RayCast2D = $RayLeft
@onready var ray_right: RayCast2D = $RayRight

func _ready() -> void:
	randomize()
	

func _physics_process(delta: float) -> void:
	if is_on_floor(): # actions
		if direction == 1:
			animated_sprite.flip_h = false
		else: # direction == -1
			animated_sprite.flip_h = true
			
		match action_num:
			0: # idle
				animated_sprite.play("idle")
			1: # dance
				animated_sprite.play("dance")
			2: # walk
				position.x += direction * walk_speed * delta
				animated_sprite.play("walk")
			3: # run
				position.x += direction * run_speed * delta
				animated_sprite.play("run")
			4: # jump for attention
				animated_sprite.play("jump")
			
	else: # falling
		velocity += get_gravity() * delta
		animated_sprite.play("fall")
	
	move_and_slide()


func action_rand():
	return randi() % 5  # 0 - 5 (6) actions

func time_rand():
	return randi() % 5 + 5  # 5 to 10 secs

func direction_rand():
	var dir = randi() % 2 # 0 or 1
	if dir == 0:
		return -1
	return dir

func _on_timer_timeout() -> void:
	# switch action and reset timer
	action_num = action_rand()
	direction = direction_rand()
	var time = time_rand()
	print("reset: ", action_num, ", ", direction, ", ", time, "secs")
	action_timer.start(time)
