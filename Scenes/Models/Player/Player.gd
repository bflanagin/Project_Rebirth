extends CharacterBody3D

###################-VARIABLES-####################

signal action(act,target)
# Camera
@export var mouse_sensitivity: float = 8.0
@export var head_path: NodePath = "Head"
@export var cam_path: NodePath = "Head/Camera3D"
@export var FOV: float = 80.0
var mouse_axis := Vector2()
@onready var head: Node3D = get_node(head_path)
@onready var cam: Camera3D = get_node(cam_path)
# Move
var can_move = true
var velocity := Vector3()
var direction := Vector3()
var move_axis := Vector2()
var snap := Vector3()
var sprint_enabled := true
var sprinting := false
# Walk
const FLOOR_MAX_ANGLE: float = deg_to_rad(46.0)
@export var gravity: float = 30.0
@export var walk_speed: int = 5
@export var sprint_speed: int = 16
@export var acceleration: int = 8
@export var deacceleration: int = 10
@export var air_control = 0.3 # (float, 0.0, 1.0, 0.05)
@export var jump_height: int = 3
var _speed: int
var _is_sprinting_input := false
var _is_jumping_input := false

<<<<<<< HEAD
onready var melee = $Head/MeleeActionRange
onready var call = $Head/CallRange
=======
@onready var melee = $Head/MeleeActionRange
@onready var call = $Head/CallRange
>>>>>>> eac3146 (no clue whats going on)

var targeting = null
var target_lock = false
var grabable = []
##################################################

# Called when the node enters the scene tree
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	cam.fov = FOV


# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(_delta: float) -> void:
	move_axis.x = Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
	move_axis.y = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	if Input.is_action_just_pressed("move_jump"):
		_is_jumping_input = true
	
	if Input.is_action_just_pressed("move_sprint"):
		_is_sprinting_input = true
	
	if Input.is_action_just_pressed("Action_1"):
		if targeting:
			if "pickup" in targeting.get_groups():
				#print(targeting.url)
				#emit_signal("action","inspect",targeting)
				if _free_hand():
					pick_up(targeting)
			elif "Allonian" in targeting.get_groups():
				target_lock = true
				targeting.go_to_player()
				targeting.connect("action", Callable(self, "_on_character_action"))
			
	if Input.is_action_pressed("Action_2"):
		if targeting:
			print(targeting.url)


# Called every physics tick. 'delta' is constant
func _physics_process(delta: float) -> void:
	if call.is_colliding():
		if targeting != call.get_collider() and !target_lock:
			if targeting:
				targeting.targeted(self,false)
				targeting = null
			else:
				for g in ["Allonian"]:
					if g in call.get_collider().get_groups():
						targeting = call.get_collider()
						targeting.targeted(self,true)
	if melee.is_colliding():
		if targeting != melee.get_collider() and !target_lock :
			if targeting:
				targeting.targeted(self,false)
				targeting = null
			else:
				for g in ["pickup","Allonian"]:
					if g in melee.get_collider().get_groups():
						targeting = melee.get_collider()
						targeting.targeted(self,true)
						
				
				
		#else:
		#	if "pickup" in melee.get_collider().get_groups():
		#		targeting = melee.get_collider()
		#		targeting.targeted(self,true)
		#if targeting:
		#	targeting.targeted(self,false)
	if can_move == true:
		walk(delta)


# Called when there is an input event
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_axis = event.relative
		camera_rotation()
				


func walk(delta: float) -> void:
	direction_input()
	
	if is_on_floor():
		snap = -get_floor_normal() - get_floor_velocity() * delta
		
		# Workaround for sliding down after jump on slope
		if velocity.y < 0:
			velocity.y = 0
		
		jump()
	else:
		# Workaround for 'vertical bump' when going off platform
		if snap != Vector3.ZERO && velocity.y != 0:
			velocity.y = 0
		
		snap = Vector3.ZERO
		
		velocity.y -= gravity * delta
	
	sprint(delta)
	
	accelerate(delta)
	
	set_velocity(velocity)
	# TODOConverter3To4 looks that snap in Godot 4 is float, not vector like in Godot 3 - previous value `snap`
	set_up_direction(Vector3.UP)
	set_floor_stop_on_slope_enabled(true)
	set_max_slides(4)
	set_floor_max_angle(FLOOR_MAX_ANGLE)
	move_and_slide()
	velocity = velocity
	_is_jumping_input = false
	_is_sprinting_input = false


func camera_rotation() -> void:
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return
	if mouse_axis.length() > 0:
		var horizontal: float = -mouse_axis.x * (mouse_sensitivity / 100)
		var vertical: float = -mouse_axis.y * (mouse_sensitivity / 100)
		
		mouse_axis = Vector2()
		
		rotate_y(deg_to_rad(horizontal))
		head.rotate_x(deg_to_rad(vertical))
		
		# Clamp mouse rotation
		var temp_rot: Vector3 = head.rotation_degrees
		temp_rot.x = clamp(temp_rot.x, -90, 90)
		head.rotation_degrees = temp_rot


func direction_input() -> void:
	direction = Vector3()
	var aim: Basis = get_global_transform().basis
	if move_axis.x >= 0.5:
		direction -= aim.z
	if move_axis.x <= -0.5:
		direction += aim.z
	if move_axis.y <= -0.5:
		direction -= aim.x
	if move_axis.y >= 0.5:
		direction += aim.x
	direction.y = 0
	direction = direction.normalized()


func accelerate(delta: float) -> void:
	# Where would the player go
	var _temp_vel: Vector3 = velocity
	var _temp_accel: float
	var _target: Vector3 = direction * _speed
	
	_temp_vel.y = 0
	if direction.dot(_temp_vel) > 0:
		_temp_accel = acceleration
		
	else:
		_temp_accel = deacceleration
	
	if not is_on_floor():
		_temp_accel *= air_control
	
	# Interpolation
	_temp_vel = _temp_vel.lerp(_target, _temp_accel * delta)
	
	velocity.x = _temp_vel.x
	velocity.z = _temp_vel.z
	
	# Make too low values zero
	if direction.dot(velocity) == 0:
		var _vel_clamp := 0.01
		if abs(velocity.x) < _vel_clamp:
			velocity.x = 0
		if abs(velocity.z) < _vel_clamp:
			velocity.z = 0


func jump() -> void:
	if _is_jumping_input:
		velocity.y = jump_height
		snap = Vector3.ZERO


func sprint(delta: float) -> void:
	if can_sprint():
		_speed = sprint_speed
		cam.set_fov(lerp(cam.fov, FOV * 1.05, delta * 8))
		sprinting = true
		
	else:
		_speed = walk_speed
		cam.set_fov(lerp(cam.fov, FOV, delta * 8))
		sprinting = false


func can_sprint() -> bool:
	return (sprint_enabled and is_on_floor() and _is_sprinting_input and move_axis.x >= 0.5)


func _on_Grabable_body_entered(body):
	if "pickup" in body.get_groups():
		if !body in grabable:
			grabable.append(body)
	pass # Replace with function body.


func _on_Grabable_body_exited(body):
	if "pickup" in body.get_groups():
		if body in grabable:
			grabable.remove(grabable.find(body))
	pass # Replace with function body.

func pick_up(target):
	if target:
		var item = target.picked_up(self)
		item.get_parent().remove_child(item)
		var free_hand = _free_hand()
		if free_hand:
			#print(item.url," in ",free_hand.name)
			free_hand.add_child(item)
			#print(free_hand.get_children())
			item.position = Vector3(0,0,0)
			
			item.show()
	#else:
	#	print("Too far away to pick up ",target)

func _free_hand():
	var free = null
	if $Head/RightHand.get_child_count() == 0:
		free = $Head/RightHand
	elif $Head/LeftHand.get_child_count() == 0:
		free = $Head/LeftHand
	return free

func _on_character_action(action):
	print("Recieved from Allonian, ",action)
	match action:
		"command_input_ready":
			print(" ready for command")
			can_move = false
			$AnimationPlayer.play("Crouch")
<<<<<<< HEAD
			targeting.get_node("Camera").make_current()
=======
			targeting.get_node("Camera3D").make_current()
>>>>>>> eac3146 (no clue whats going on)
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pass
