extends Node2D

var move_speed = 4
var direction = Vector2(1, 0) # moving on x axis
var is_idle = false

func _input(event: InputEvent) -> void:
	# check for a click (left mouse button)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if not is_idle:
			#is_idle = true
			start_idle()

func start_idle():
	is_idle = true
	$AnimatedSprite2D.play('idle')
	
	await get_tree().create_timer(3.0).timeout
	# times up!
	is_idle = false
	$AnimatedSprite2D.play("walk")

func _ready() -> void:
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
	window.position = Vector2i(0, target_y)
	
	# run once at start
	_update_mouse_mask()
	
	# connect that signal: update mask each frame
	$AnimatedSprite2D.frame_changed.connect(_update_mouse_mask)
	$AnimatedSprite2D.play("walk")

func _process(_delta: float) -> void:
	if is_idle:
		return
	
	var window = get_window()
	
	# calculate the move
	var move_vector = Vector2i(direction * move_speed)
	
	# apply it to the OS window
	window.position += move_vector
	
	# the safe zone: screen area minus taskbars/docks
	var usable_rect = DisplayServer.screen_get_usable_rect()
	
	# check if hitting right or left side
	# if right side of our window > right side of the screen
	if window.position.x + window.size.x > usable_rect.end.x:
		direction.x = -1
		$AnimatedSprite2D.flip_h = true
	elif window.position.x < usable_rect.position.x:
		direction.x = 1
		$AnimatedSprite2D.flip_h = false

func _update_mouse_mask():
	var anim = $AnimatedSprite2D
	
	# get raw image data of current sprite frame
	var texture = anim.sprite_frames.get_frame_texture(anim.animation, anim.frame)
	var image = texture.get_image()
	
	# flip image data manually
	if anim.flip_h:
		image.flip_x()
	
	# create bit map (solid pixels)
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(image)
	
	# create polygon shape around sprite frame
	# (0.1 means ignore transparent pixels)
	var polygons = bitmap.opaque_to_polygons(Rect2(Vector2.ZERO, texture.get_size()), 0.1)
	
	# apply to OS window
	# basically like a collider, only accepts mouse
	# events inside this shape
	DisplayServer.window_set_mouse_passthrough(polygons)
	#print(polygons)
	
