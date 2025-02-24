extends Area2D

@export var offset_x: float = 40.0  # Distance from player's center

func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()

	# Adjust gun position relative to the player
	position.x = offset_x  # Always stay on the right side

	# Ensure gun always tracks the cursor properly
	rotation = (mouse_pos - global_position).angle()
