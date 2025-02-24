extends Camera2D

@export var player1: CharacterBody2D = null
@export var player2: CharacterBody2D = null
@export var zoom_normal: Vector2 = Vector2(1, 1)  # Normal zoom level
@export var zoom_in: Vector2 = Vector2(1.5, 1.5)  # Zoom-in level
@export var zoom_speed: float = 5.0  # Zoom transition speed

var current_target: CharacterBody2D = null  # Start without a target

func _ready() -> void:
	# Wait until both players exist before setting the target
	if player1 == null or player2 == null:
		print("Error: Player1 or Player2 is not assigned to CameraController.")
		return

	# Start with Player 1 as the initial focus
	current_target = player1
	position = current_target.position  # Set camera position
	zoom = zoom_normal  # Set default zoom level

func _process(delta: float) -> void:
	# Ensure players exist before accessing their properties
	if player1 == null or player2 == null:
		return  # Prevent errors if players are not assigned

	# Detect Player 1 movement
	if Input.is_action_pressed("player_left") or Input.is_action_pressed("player_right") or Input.is_action_pressed("player_up") or Input.is_action_pressed("player_down"):
		switch_target(player1)
		zoom = zoom_normal

	# Detect Player 2 movement
	elif Input.is_action_pressed("player_left_2") or Input.is_action_pressed("player_right_2") or Input.is_action_pressed("player_up_2") or Input.is_action_pressed("player_down_2"):
		switch_target(player2)
		zoom = zoom_normal

	# Smoothly move the camera towards the current target
	if current_target:
		position = position.lerp(current_target.position, delta * 5)  # Smooth follow

	# Smooth zoom transition
	zoom = zoom.lerp(zoom_in if zoom != zoom_normal else zoom_normal, delta * zoom_speed)

func switch_target(new_target: CharacterBody2D):
	if current_target != new_target:
		current_target = new_target
		zoom = zoom_in  # Apply zoom-in effect
