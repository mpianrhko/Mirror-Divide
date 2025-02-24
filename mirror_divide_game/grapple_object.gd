extends Area2D

var is_grabbed: bool = false
var pull_speed: float = 600.0  # Speed at which object moves toward the player
var grabber: Node = null  # Stores reference to the player that grabbed it
var grapple_hook: Node = null  # Stores the hook (Gun_2) that pulled it

func grabbed(player, hook):
	if is_grabbed:
		return

	is_grabbed = true
	grabber = player  # Store reference to the player
	grapple_hook = hook  # Store reference to the hook
	set_process(true)  # Enable movement towards player

	print("Object grabbed, following hook:", grapple_hook.name)

func released():
	is_grabbed = false
	grabber = null
	grapple_hook = null
	set_process(false)  # Stop movement
	print("Object released, stopping movement.")

func _process(delta: float):
	if is_grabbed and grapple_hook:
		# Move toward the grappling hook (Gun_2)
		var move_direction = (grapple_hook.global_position - global_position).normalized()
		global_position += move_direction * pull_speed * delta

		# Stop moving if close enough to hook
		if global_position.distance_to(grapple_hook.global_position) < 10:
			is_grabbed = false
			print("Object reached hook, stopping movement.")
