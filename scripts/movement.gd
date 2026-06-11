extends Node2D

const SPEED = 60.0

# gravity from project settings
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# adding the gravity
	if not is_on_floor():
		position.x += SPEED * delta
		velocity.y += gravity * delta
