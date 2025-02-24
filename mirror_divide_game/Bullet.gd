extends Area2D

@export var speed: float = 500.0
var bullet_direction = Vector2.ZERO

func _process(delta: float) -> void:
	position += bullet_direction * speed * delta  # Move in correct directiona
