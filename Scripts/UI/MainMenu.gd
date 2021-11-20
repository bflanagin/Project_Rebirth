extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var menuType = "CenterMenu"

#signal play()
#signal load_game()
#signal quit_game()
#signal settings()
signal intent(action)
# Called when the node enters the scene tree for the first time.
func _ready():
	var themenu = load("res://Scenes/UI/Elements/"+str(menuType)+".tscn")
	var menuInstance = themenu.instance()
	menuInstance.connect("intent",self,'_on_signal')
	add_child(menuInstance)
	#$Camera.make_current()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_signal(sig):
	#print("From Main Menu ", sig)
	if sig == "play":
		$AudioStreamPlayer.stop()
	emit_signal("intent",sig)


func _on_MainMenu_visibility_changed():
	if visible:
		get_node(str(menuType)).show()
	else:
		get_node(str(menuType)).hide()
	pass # Replace with function body.
