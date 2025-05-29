<<<<<<< HEAD
extends Spatial
=======
extends Node3D
>>>>>>> eac3146 (no clue whats going on)

var Ratios = ["res://Scenes/UI/Quad1-1.tscn","res://Scenes/UI/Quad3-2.tscn","res://Scenes/UI/Quad2-3.tscn","res://Scenes/UI/Quad4-3.tscn","res://Scenes/UI/Quad4-9.tscn"]

# The size of the quad mesh itself.
var quad_mesh_size
# Used for checking if the mouse is inside the Area
var is_mouse_inside = false
# Used for checking if the mouse was pressed inside the Area
var is_mouse_held = false
# The last non-empty mouse position. Used when dragging outside of the box.
var last_mouse_pos3D = null
# The last processed input touch/mouse event. To calculate relative movement.
var last_mouse_pos2D = null

<<<<<<< HEAD
export var UI = ""
export var handle_input = true

export var distance = 4
=======
@export var UI = ""
@export var handle_input = true

@export var distance = 4
>>>>>>> eac3146 (no clue whats going on)

#var qua = preload("res://scenes/Quad.tscn")


#onready var quad_instance = qua.instance()
<<<<<<< HEAD
onready var node_viewport = $Viewport
=======
@onready var node_viewport = $SubViewport
>>>>>>> eac3146 (no clue whats going on)
var node_quad = ""
var node_area = ""



<<<<<<< HEAD
export var resolution = Vector2(1024,768)
export(int, FLAGS,"1:1","3:2","2:3","4:3","4:9") var ratio = 1
=======
@export var resolution = Vector2(1024,768)
@export var ratio = 1 # (int, FLAGS,"1:1","3:2","2:3","4:3","4:9")
>>>>>>> eac3146 (no clue whats going on)

signal finished(menu)

signal relay(baton)
signal to_ui(data)


func display_setup():
<<<<<<< HEAD
	node_viewport = $Viewport
=======
	node_viewport = $SubViewport
>>>>>>> eac3146 (no clue whats going on)
	var quad_instance
	match ratio:
		1:
			
			quad_instance = load(Ratios[0]).instance()
		2:
			quad_instance = load(Ratios[1]).instance()
		4:
			quad_instance = load(Ratios[2]).instance()
		8:
			quad_instance = load(Ratios[3]).instance()
		16:
			quad_instance = load(Ratios[4]).instance()
	
	node_quad = quad_instance
<<<<<<< HEAD
	node_area = node_quad.get_node("Area")
=======
	node_area = node_quad.get_node("Area3D")
>>>>>>> eac3146 (no clue whats going on)
	add_child(quad_instance)
	node_viewport.set_size(resolution)

func _ready():

	if UI != "":
		if load_ui(UI) == 1:
<<<<<<< HEAD
			var viewport = node_quad.get_surface_material(0).get_texture(0)
			viewport.set_viewport_path_in_scene("../Viewport")
			node_area.connect("mouse_entered", self, "_mouse_entered_area")
=======
			var viewport = node_quad.get_surface_override_material(0).get_texture(0)
			viewport.set_viewport_path_in_scene("../SubViewport")
			node_area.connect("mouse_entered", Callable(self, "_mouse_entered_area"))
>>>>>>> eac3146 (no clue whats going on)
			emit_signal("relay",["ui","ready"])
		
	else:
		display_setup()
<<<<<<< HEAD
		var viewport = node_quad.get_surface_material(0).get_texture(0)
		viewport.set_viewport_path_in_scene("../Viewport")
		
		# If the material is NOT set to use billboard settings, then avoid running billboard specific code
	if node_quad.get_surface_material(0).params_billboard_mode == 0:
=======
		var viewport = node_quad.get_surface_override_material(0).get_texture(0)
		viewport.set_viewport_path_in_scene("../SubViewport")
		
		# If the material is NOT set to use billboard settings, then avoid running billboard specific code
	if node_quad.get_surface_override_material(0).params_billboard_mode == 0:
>>>>>>> eac3146 (no clue whats going on)
		set_process(false)

		
func call_runner(data):
	emit_signal("relay",data)

func _process(_delta):
	# NOTE: Remove this function if you don't plan on using billboard settings.
	rotate_area_to_billboard()


func _mouse_entered_area():
	is_mouse_inside = true


func _unhandled_input(event):
	# Check if the event is a non-mouse/non-touch event
	var is_mouse_event = false
<<<<<<< HEAD
	for mouse_event in [InputEventMouseButton, InputEventMouseMotion, InputEventScreenDrag, InputEventScreenTouch]:
		if event is mouse_event:
			is_mouse_event = true
			break
=======
	#for mouse_event in [InputEventMouseButton, InputEventMouseMotion, InputEventScreenDrag, InputEventScreenTouch]:
	if event is InputEventMouse:
		is_mouse_event = true
		#break
>>>>>>> eac3146 (no clue whats going on)
	
	# If the event is a mouse/touch event and/or the mouse is either held or inside the area, then
	# we need to do some additional processing in the handle_mouse function before passing the event to the viewport.
	# If the event is not a mouse/touch event, then we can just pass the event directly to the viewport.
	if handle_input == true and is_mouse_event and (is_mouse_inside or is_mouse_held):
		handle_mouse(event)
	elif not is_mouse_event and handle_input == true:
		node_viewport.input(event)


# Handle mouse events inside Area. (Area.input_event had many issues with dragging)
func handle_mouse(event):
	# Get mesh size to detect edges and make conversions. This code only support PlaneMesh and QuadMesh.
	quad_mesh_size = node_quad.mesh.size
	
	# Detect mouse being held to mantain event while outside of bounds. Avoid orphan clicks
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		is_mouse_held = event.pressed
	
	# Find mouse position in Area
	var mouse_pos3D = find_mouse(event.global_position)
	
	# Check if the mouse is outside of bounds, use last position to avoid errors
	# NOTE: mouse_exited signal was unrealiable in this situation
	is_mouse_inside = mouse_pos3D != null
	if is_mouse_inside:
		# Convert click_pos from world coordinate space to a coordinate space relative to the Area node.
		# NOTE: affine_inverse accounts for the Area node's scale, rotation, and translation in the scene!
		mouse_pos3D = node_area.global_transform.affine_inverse() * mouse_pos3D
		last_mouse_pos3D = mouse_pos3D
	else:
		mouse_pos3D = last_mouse_pos3D
		if mouse_pos3D == null:
			mouse_pos3D = Vector3.ZERO
	
	# TODO: adapt to bilboard mode or avoid completely
	
	# convert the relative event position from 3D to 2D
	var mouse_pos2D = Vector2(mouse_pos3D.x, -mouse_pos3D.y)
	
	# Right now the event position's range is the following: (-quad_size/2) -> (quad_size/2)
	# We need to convert it into the following range: 0 -> quad_size
	mouse_pos2D.x += quad_mesh_size.x / 2
	mouse_pos2D.y += quad_mesh_size.y / 2
	# Then we need to convert it into the following range: 0 -> 1
	mouse_pos2D.x = mouse_pos2D.x / quad_mesh_size.x
	mouse_pos2D.y = mouse_pos2D.y / quad_mesh_size.y
	
	# Finally, we convert the position to the following range: 0 -> viewport.size
	mouse_pos2D.x = mouse_pos2D.x * node_viewport.size.x
	mouse_pos2D.y = mouse_pos2D.y * node_viewport.size.y
	# We need to do these conversions so the event's position is in the viewport's coordinate system.
	
	# Set the event's position and global position.
	event.position = mouse_pos2D
	event.global_position = mouse_pos2D
	
	# If the event is a mouse motion event...
	if event is InputEventMouseMotion:
		# If there is not a stored previous position, then we'll assume there is no relative motion.
		if last_mouse_pos2D == null:
			event.relative = Vector2(0, 0)
		# If there is a stored previous position, then we'll calculate the relative position by subtracting
		# the previous position from the new position. This will give us the distance the event traveled from prev_pos
		else:
			event.relative = mouse_pos2D - last_mouse_pos2D
	# Update last_mouse_pos2D with the position we just calculated.
	last_mouse_pos2D = mouse_pos2D
	
	# Finally, send the processed input event to the viewport.
	node_viewport.input(event)


func find_mouse(global_position):
<<<<<<< HEAD
	var camera = get_viewport().get_camera()
=======
	var camera = get_viewport().get_camera_3d()
>>>>>>> eac3146 (no clue whats going on)
	
	# From camera center to the mouse position in the Area
	var from = camera.project_ray_origin(global_position)
	var dist = find_further_distance_to(camera.transform.origin)
	var to = from + camera.project_ray_normal(global_position) * dist
	# Manually raycasts the are to find the mouse position
<<<<<<< HEAD
	var result = get_world().direct_space_state.intersect_ray(from, to, [], node_area.collision_layer,false,true) #for 3.1 changes
=======
	var params = PhysicsDirectBodyState3D(from, to, [], node_area.collision_layer,false,true)
	var result = get_world_3d().direct_space_state.intersect_ray(params) #for 3.1 changes
>>>>>>> eac3146 (no clue whats going on)
	if result.size() > 0:
		return result.position
	else:
		return null


func find_further_distance_to(origin):
	# Find edges of collision and change to global positions
	var edges = []
	edges.append(node_area.to_global(Vector3(quad_mesh_size.x / 2, quad_mesh_size.y / 2, 0)))
	edges.append(node_area.to_global(Vector3(quad_mesh_size.x / 2, -quad_mesh_size.y / 2, 0)))
	edges.append(node_area.to_global(Vector3(-quad_mesh_size.x / 2, quad_mesh_size.y / 2, 0)))
	edges.append(node_area.to_global(Vector3(-quad_mesh_size.x / 2, -quad_mesh_size.y / 2, 0)))
	
	# Get the furthest distance between the camera and collision to avoid raycasting too far or too short
	var far_dist = distance
	var temp_dist
	for edge in edges:
		temp_dist = origin.distance_to(edge)
		if temp_dist > far_dist:
			far_dist = temp_dist
	
	return far_dist


func rotate_area_to_billboard():
<<<<<<< HEAD
	var billboard_mode = node_quad.get_surface_material(0).params_billboard_mode
=======
	var billboard_mode = node_quad.get_surface_override_material(0).params_billboard_mode
>>>>>>> eac3146 (no clue whats going on)
	
	# Try to match the area with the material's billboard setting, if enabled
	if billboard_mode > 0:
		# Get the camera
<<<<<<< HEAD
		var camera = get_viewport().get_camera()
		# Look in the same direction as the camera
		var look = camera.to_global(Vector3(0, 0, -100)) - camera.global_transform.origin
		look = node_area.translation + look
=======
		var camera = get_viewport().get_camera_3d()
		# Look in the same direction as the camera
		var look = camera.to_global(Vector3(0, 0, -100)) - camera.global_transform.origin
		look = node_area.position + look
>>>>>>> eac3146 (no clue whats going on)
		
		# Y-Billboard: Lock Y rotation, but gives bad results if the camera is tilted.
		if billboard_mode == 2:
			look = Vector3(look.x, 0, look.z)
		
		node_area.look_at(look, Vector3.UP)
		
		# Rotate in the Z axis to compensate camera tilt
		node_area.rotate_object_local(Vector3.BACK, camera.rotation.z)

func _on_ui_finished(ui):
	emit_signal("finished",ui)
	#$Viewport.remove_child(get_child(0))

func from_Above(data):
	emit_signal("to_ui",data)
	
func load_ui(path):
	display_setup()
	if node_viewport.get_child_count() > 0:
		var child = node_viewport.get_child(0)
		node_viewport.remove_child(child)
		child.queue_free()
		
	var display = load(path)
<<<<<<< HEAD
	node_viewport.add_child(display.instance())
	if node_viewport.get_child_count() == 1:
		if !node_viewport.get_child(0).is_connected("finished",self,"_on_ui_finished"):
			var _error = node_viewport.get_child(0).connect("finished",self,"_on_ui_finished")
			_error = connect("to_ui",node_viewport.get_child(0),"from_Above")
	return 1
	
func update_internal(data):
	node_viewport = $Viewport
=======
	node_viewport.add_child(display.instantiate())
	if node_viewport.get_child_count() == 1:
		if !node_viewport.get_child(0).is_connected("finished", Callable(self, "_on_ui_finished")):
			var _error = node_viewport.get_child(0).connect("finished", Callable(self, "_on_ui_finished"))
			_error = connect("to_ui", Callable(node_viewport.get_child(0), "from_Above"))
	return 1
	
func update_internal(data):
	node_viewport = $SubViewport
>>>>>>> eac3146 (no clue whats going on)
	if node_viewport.get_child_count() > 0:
		node_viewport.get_child(0).data_update(data)

func force_resize():
	node_viewport.set_size(resolution)
	#node_quad.duplicate() 
	#node_quad.mesh.set_size(ratio)


func _on_GUIPanel3D_visibility_changed():
	if visible:
		if node_viewport.get_child_count() == 1:
			node_viewport.get_child(0).show()
			force_resize()
	else:
		if node_viewport.get_child_count() == 1:
			node_viewport.get_child(0).hide()
			
	pass # Replace with function body.
