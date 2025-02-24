extends CharacterBody2D

@export var speed := 100.0
@export var jump_strength := -400.0  # Same as player
const GRAVITY = 1000.0  # Ensure same gravity as player

var direction := Vector2.ZERO
var rng = RandomNumberGenerator.new()
var movement_timer: Timer

func _ready():
	movement_timer = $Timer  # Assign Timer node reference
	if movement_timer:
		movement_timer.wait_time = rng.randf_range(1.0, 3.0)  # Random interval
		movement_timer.start()
		movement_timer.timeout.connect(_on_Timer_timeout)  # Ensure callback is connected

	change_direction()  # Initialize with a random direction

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Move in the chosen direction
	velocity.x = direction.x * speed
	
	# Handle movement and jumping
	move_and_slide()

	# Change direction upon collision with a wall
	if is_on_wall():
		direction.x *= -1

func change_direction():
	var choices = [-1, 0, 1]  # -1 for left, 0 for idle, 1 for right
	direction.x = rng.randi_range(-1, 1)  # Random left, right, or idle

	# Random chance to jump
	if is_on_floor() and rng.randf() < 0.4:  # 40% chance to jump
		velocity.y = jump_strength

	# Restart timer with a new random wait time
	if movement_timer:
		movement_timer.wait_time = rng.randf_range(1.0, 3.0)
		movement_timer.start()

func _on_Timer_timeout():
	change_direction()
