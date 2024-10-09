extends CharacterBody3D

const JUMP_VELOCITY = 4.5

@export_category("Locomotion")
@export var _walking_speed : float = 2
@export var _running_speed : float = 6
@export var _acceleration : float = 6
@export var _decelartion : float = 12
@export var _rotation_speed : float = PI * 2
var _xz_velocity : Vector3
var _direction : Vector3
@onready var _movement_speed : float = _walking_speed

@export_category("Jumping")
@export var _max_jump_height : float = 2.5
@export var _min_jump_height : float = 2.5
@export var _mass : float = 1
@export var _air_control : float = 0.5 
@export var _air_brakes : float = 0.5

@onready var _animation : AnimationTree = $AnimationTree
@onready var _state_machine : AnimationNodeStateMachinePlayback = _animation["parameters/playback"]
@onready var _rig : Node3D = $Rig
@onready var _jump_hold_timer : Timer = $"Jump Hold Timer"

func move(direction : Vector3) -> void:
	_direction = direction
	
func set_running(running : bool) -> void:
	if running:
		_movement_speed = _running_speed
	else:
		_movement_speed = _walking_speed
		
func start_jump() -> void:
	if is_on_floor():
		_state_machine.travel("Jump_Start")
		_jump_hold_timer.start()
		_jump_hold_timer.paused = false
		
func stop_jump() -> void:
	_jump_hold_timer.paused = true
		
func _apply_jump_velocity() -> void:
	var _min_vel : float = sqrt(_min_jump_height * -get_gravity().y * _mass * 2)
	var _max_vel : float = sqrt(_max_jump_height * -get_gravity().y * _mass * 2)  
	velocity.y = _min_vel + (_max_vel - _min_vel) * min(1 - _jump_hold_timer.time_left, 0.3) / 0.3

func _physics_process(delta: float) -> void:
	# figure out what angle we're rotating to
	if _direction:
		var _target_angle : float = atan2(_direction.x, _direction.z)
		var _angle_diff : float = wrapf(_target_angle - _rig.rotation.y, -PI, PI) 
		_rig.rotation.y += clamp(_rotation_speed * delta, 0, abs(_angle_diff)) * sign(_angle_diff)

	_xz_velocity = Vector3(velocity.x, 0, velocity.z)
		
	if is_on_floor():
		_ground_physics(delta)
	else:
		_air_physics(delta)
			
	velocity.x = _xz_velocity.x
	velocity.z = _xz_velocity.z
	
	move_and_slide()

func _ground_physics(delta : float) -> void:
	if _direction:
		# accelerate
		if _direction.dot(velocity) > 0:
			_xz_velocity = _xz_velocity.move_toward(_direction * _movement_speed, _acceleration * delta)
		# turn around
		else:
			_xz_velocity = _xz_velocity.move_toward(_direction * _movement_speed, _decelartion * delta)
	# decelerate
	else:
		_xz_velocity = _xz_velocity.move_toward(Vector3.ZERO, _decelartion * delta)		
	
	_animation.set(
		"parameters/Locomotion/blend_position", 
		_xz_velocity.length() / _running_speed
	)
	
func _air_physics(delta : float) -> void:
	velocity += get_gravity() * _mass * delta
	
	if _direction:
		# accelerate
		if _direction.dot(velocity) > 0:
			_xz_velocity = _xz_velocity.move_toward(_direction * _movement_speed, _acceleration * _air_control * delta)
		# turn around
		else:
			_xz_velocity = _xz_velocity.move_toward(_direction * _movement_speed, _decelartion * _air_control * delta)
	# decelerate
	else:
		_xz_velocity = _xz_velocity.move_toward(Vector3.ZERO, _decelartion * _air_brakes * delta)		
	
