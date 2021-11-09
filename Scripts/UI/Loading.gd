extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var new_scene = ""
var player_data = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().connect("scene_changed",self,"_on_scene_changed")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Loading_visibility_changed():
	if(visible):
		$Camera.current = true
		$Timer.start()
		get_parent().get_node("SettingsMenu").hide()
		get_parent().get_node("MainMenu").hide()
		#_load()
		
	pass # Replace with function body.

func _load():
	var load_to = get_parent()
	match new_scene:
		"mainMenu":
			pass
		_:
			var newScene = load(new_scene).instance()
			load_to.add_child(newScene)
			load_to.remove_old_scene(newScene)
			
	
func load_scene(_scene):
	new_scene = _scene
	show()
	

func _on_scene_changed():
	hide()

func _on_Timer_timeout():
	_load()
	$Timer.stop()
	pass # Replace with function body.
