extends Node

@export var _character : CharacterBody3D
@export var _camera_spring_arm : SpringArm3D

func _input(event : InputEvent):
	if event.is_action_pressed("run"):
		_character.set_running(true)
	elif event.is_action_released("run"):
		_character.set_running(false)
		
	if event.is_action_pressed("jump"):
		_character.start_jump()
	elif event.is_action_released("jump"):
		_character.stop_jump()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_camera_spring_arm.look(Input.get_vector("look_left", "look_right", "look_up", "look_down") * delta)
	
	var input_direction = Input.get_vector("move_left", "move_right", "move_backward", "move_forward")
	var move_direction = (_camera_spring_arm.basis.x * Vector3(1, 0, 1)).normalized() * input_direction.x
	move_direction -= (_camera_spring_arm.basis.z * Vector3(1, 0, 1)).normalized() * input_direction.y 
	_character.move(move_direction)
	
	
