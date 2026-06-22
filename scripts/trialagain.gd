extends Node2D

var move_speed = 4
var direction = Vector2(1, 1) # moving on both axis
var is_idle = false
var action_num = -1

func _input(event: InputEvent) -> void:
	# check for a click (left mouse button)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("mouse clicked")
		if not is_idle:
			start_idle()

func start_idle():
	is_idle = true
	$AnimatedSprite2D.play('idle')
	
	await get_tree().create_timer(3.0).timeout
	# times up!
	is_idle = false
	$AnimatedSprite2D.play("walk")

func _ready() -> void:
	randomize()
	
	# get access to the actual OS window (not just the game node)
	var window = get_window()
	
	# transparency setup
	get_viewport().transparent_bg = true
	window.transparent = true
	
	# window shape
	window.borderless = true
	window.always_on_top = true
	window.unresizable = false
	
	# safe zone
	var usable_rect = DisplayServer.screen_get_usable_rect()
	
	# find the floor
	var target_y = usable_rect.end.y - window.size.y + 6
	
	# put pet on floor
	window.position = Vector2i(2000, target_y)
	
	$AnimatedSprite2D.play("idle")

func _process(_delta: float) -> void:
	if is_idle:
		return
	
	var window = get_window()
	
	# calculate the move
	var move_vector = Vector2i(direction * move_speed)
	
	# apply it to the OS window
	#window.position += move_vector
	
	# the safe zone: screen area minus taskbars/docks
	var usable_rect = DisplayServer.screen_get_usable_rect()
	
	# check if hitting right or left side
	# if right side of our window > right side of the screen
	if window.position.x + window.size.x > usable_rect.end.x:
		direction.x = -1
	elif window.position.x < usable_rect.position.x:
		direction.x = 1
	
	# check if hitting floor or ceiling
	if window.position.y + window.size.y > usable_rect.end.y:
		direction.y = -1
	elif window.position.y < usable_rect.position.y:
		direction.y = 1
	
	if direction.x == -1:
		$AnimatedSprite2D.flip_h = true
	else: # direction == 1
		$AnimatedSprite2D.flip_h = false
	
	match action_num:
		0: # idle
			$AnimatedSprite2D.play("idle")
		1: # dance
			$AnimatedSprite2D.play("dance")
		2: # spin
			$AnimatedSprite2D.play("spin")
		3: # jump in place
			$AnimatedSprite2D.play("jump")
		4, 5, 6, 7: # walk
			$AnimatedSprite2D.play("walk")
			window.position += move_vector
	

func action_rand():
	return randi() % 8  # 0 - 5 (6) actions

func time_rand():
	return randi() % 5 + 5  # 5 to 10 secs

func direction_rand():
	# -1, 0, 1
	var dir_x = action_rand() % 3 - 1
	var dir_y = 0
	if dir_x != 0:
		dir_y = time_rand() % 3 - 1
	else:
		dir_y = time_rand() % 2
		if dir_y == 0:
			dir_y = -1
	return Vector2i(dir_x, dir_y)

func _on_timer_timeout() -> void:
	# switch action and reset timer
	action_num = action_rand()
	direction = direction_rand()
	var time = time_rand()
	print("reset: ", action_num, ", ", direction, ", ", time, "secs")
	$Timer.start(time)
