extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var ydt: float = 1


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y = min(velocity.y + gravity * delta, 5000)

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	var direction_y = -Input.get_axis("ui_down", "ui_up")
	if direction_y:
		velocity.y = direction_y * SPEED
		ydt = 0
	elif ydt < 1:
		velocity.y = 0
		ydt += delta

	move_and_slide()
