extends KinematicBody

var head = preload("res://Scenes/Models/Components/Series1/Heads/head1.tscn")
var eyes = preload("res://Scenes/Models/Components/Series1/Eyes/eyes7.tscn")

const GRAVITY = -24.8
var vel = Vector3()
const MAX_SPEED = 2
const JUMP_SPEED = 18
const ACCEL = 4.5

var dir = Vector3()

const DEACCEL= 16
const MAX_SLOPE_ANGLE = 40

var state = "starting"
var target = null

var player = null
var awaiting_command = false

signal action(act)
## Navigation for AI and unit command (Might move to Mistro)
export var navigationNode = ""
onready var camera = get_node(navigationNode+"/Player/Head/Camera")
onready var navi = get_node(navigationNode)
var path = []
var show_path = true
var camrot = 0.0
var m = SpatialMaterial.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$base1/AnimationPlayer.play("rest1")
	build_body(head,eyes)
	#path.append(self.translation)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):

#	pass

func _physics_process(delta):
	var step_size = MAX_SPEED
	if !awaiting_command and !target:
		 target = Mistro.find_target(navi.get_node("Files"))
		 $change_mind.start()
		 path = navi.get_simple_path(self.translation, target.translation, true)
	if path.size() > 0:
		if path[0] != self.translation:
			state = "movement"
		# Direction is the difference between where we are now
		# and where we want to go.
		var destination = path[0]
		dir = destination - self.translation

		# If the next node is closer than we intend to 'step', then
		# take a smaller step. Otherwise we would go past it and
		# potentially go through a wall or over a cliff edge!
		if step_size > dir.length():
			step_size = dir.length()
			# We should also remove this node since we're about to reach it.
			path.remove(0)

			# Move the robot towards the path node, by how far we want to travel.
			# Note: For a KinematicBody, we would instead use move_and_slide
			# so collisions work properly.
		#self.translation += dir.normalized() * step_size

		# Lastly let's make sure we're looking in the direction we're traveling.
		# Clamp y to 0 so the robot only looks left and right, not up/down.
		dir.y = 0
		if dir:
			# Direction is relative, so apply it to the robot's location to
			# get a point we can actually look at.
			var look_at_point = self.translation + dir.normalized()
			# Make the robot look at the point.
			self.look_at(look_at_point, Vector3.UP)
	elif path.size() == 0 && !state in ["starting","stopped","resting"]:
		state = "stopped"
		Mistro.process_movement(self,delta)
	if state == "movement":
		$base1/AnimationPlayer.playback_speed = MAX_SPEED * 2
		$base1/AnimationPlayer.play("walk")
		Mistro.process_movement(self,delta)
	elif state == "stopped":
		if $base1/AnimationPlayer.current_animation != "stop":
			$base1/AnimationPlayer.playback_speed = 1
			$base1/AnimationPlayer.play("stop")
			Mistro.process_movement(self,delta)
	elif state == "starting":
		Mistro.process_movement(self,delta)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "stop":
		$base1/AnimationPlayer.play("rest1")
		state = "resting"
		target = null
		$change_mind.stop()
		if awaiting_command:
			print("Informing player I'm ready")
			emit_signal("action","command_input_ready")
	pass # Replace with function body.


func _on_AnimationPlayer_animation_changed(old_name, new_name):
	
	pass # Replace with function body.


func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name == "walk":
		$base1/AnimationPlayer.get_animation("walk").loop = true
	else:
		$base1/AnimationPlayer.get_animation("walk").loop = false
	pass # Replace with function body.


func _on_change_mind_timeout():
	target = Mistro.find_target(navi.get_node("Files"))
	$change_mind.start()
	path = navi.get_simple_path(self.translation, target.translation, true)
	pass # Replace with function body.


func _on_Hearing_body_entered(body):
	if "Player" in body.get_groups():
		player = body
	
	pass # Replace with function body.


func _on_Hearing_body_exited(body):
	if "Player" in body.get_groups():
		player = body
	pass # Replace with function body.

func go_to_player():
	target = player
	$change_mind.stop()
	awaiting_command = true
	path = navi.get_simple_path(self.translation, target.translation, true)

func targeted(by,currently):
	if currently == true:
		player = by
	pass

func build_body(h,e):
	var he = h.instance()
	var ey = e.instance()
	ey.transform = he.get_node("eye_position").transform
	he.get_node("eye_position").add_child(ey)
	#he.rotate(Vector3(1,1,1),90)
	$base1/Armature/Skeleton.add_child(he)
	he.transform = $base1/Armature/Skeleton.get_bone_pose(1)
	$base1/Armature/Skeleton.bind_child_node_to_bone(1,he)
