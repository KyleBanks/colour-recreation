extends SpringArm3D

@export var _rotation_speed : float = 1
@export var _min_x : float = -1
@export var _max_x : float = 1

func look(direction : Vector2) -> void:
	rotation.x = clampf(rotation.x + direction.y * _rotation_speed, _min_x, _max_x)
	rotation.y += direction.x * _rotation_speed
