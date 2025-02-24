extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 1000.0

@onready var sprite = $AnimatedSprite2D  # Reference to sprite
@onready var grab_area: Area2D = null  # Reference to grab hitbox (Area2D)

var grabbed_object: Node = null  # Store grabbed object reference

func _ready() -> void:
	# Ensure GrabArea exists before using it
	if has_node("GrabArea"):
		grab_area = $GrabArea
	else:
		print("Error: GrabArea node is missing from Player 2!")

func _physics_process(delta: float) -> void:
	# Apply gravity if not on the floor
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Handle jump
	if Input.is_action_just_pressed("player_up_2") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		sprite.play("jump")  # Play jump animation

	# Get movement direction
	var direction = Vector2.ZERO
	if Input.is_action_pressed("player_left_2"):
		direction.x = -1
	if Input.is_action_pressed("player_right_2"):
		direction.x = 1

	# Apply movement speed
	velocity.x = direction.x * SPEED

	# Handle animations (play "grab" while holding right-click)
	if Input.is_action_pressed("player_grab_2"):
		sprite.play("grab")  # Switch to grab animation
	else:
		if direction.x != 0:
			sprite.play("run")
		else:
			sprite.play("idle")  # Default idle animation

	# Handle grabbing objects
	if Input.is_action_just_pressed("player_grab_2"):
		attempt_grab()

	if Input.is_action_just_released("player_grab_2"):
		release_grab()

	move_and_slide()

func attempt_grab():
	if grab_area == null:
		print("Error: GrabArea is not assigned!")
		return

	# Detect objects inside the grab area
	for body in grab_area.get_overlapping_bodies():
		if body.has_method("grabbed"):  # Check if the object can be grabbed
			grabbed_object = body
			body.grabbed(self)  # Call object's grabbed function
			body.reparent(self)  # Attach the object to Player 2
			body.position = Vector2(10, -10)  # Adjust position near player
			print("Grabbed:", body.name)
			break  # Stop after grabbing the first valid object

func release_grab():
	if grabbed_object:
		grabbed_object.reparent(get_parent())  # Detach from the player
		grabbed_object.released()  # Call release function on the object
		grabbed_object = null  # Clear grabbed reference

	# Revert animation to idle
	sprite.play("idle")
