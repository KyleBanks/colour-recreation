extends Node3D
class_name ColourSource

@export var _radius: float = 3

func packed() -> Vector4:
	return Vector4(global_position.x, global_position.y, global_position.z, _radius)
