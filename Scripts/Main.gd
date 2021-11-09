extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var appname = "game"
signal selection(sig)
signal scene_changed()
var loadingScreenFile = preload("res://Scenes/UI/Loading.tscn")
var loadingScreen = loadingScreenFile.instance()
var oldScene
# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(loadingScreen)
	_on_first_load()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# This loads the first scenes needed to create a game. 
func _on_first_load():
	appname = "V0.01"
	var attract = load("res://Scenes/Levels/Attract.tscn").instance()
	var mainMenu = load("res://Scenes/UI/MainMenu.tscn").instance()
	var settingsMenu = load("res://Scenes/UI/SettingsMenu.tscn").instance()
	settingsMenu.menuType = "CenterMenu"
	
	mainMenu.menuType = "LeftMenu"
	add_child(mainMenu)
	add_child(settingsMenu)
	add_child(attract)
	
	mainMenu.connect("intent",self,"_on_menu_signal")
	settingsMenu.connect("intent",self,"_on_menu_signal")
	get_node("SettingsMenu").hide()
	get_node("Loading").hide()
	oldScene = attract
	

func _on_menu_signal(sig):
	#print(sig)
	match sig:
		"quit_game":
			$AudioStreamPlayer.play()
			get_tree().quit()
		"play":
			#print(sig)
			$AudioStreamPlayer.play()
			$Loading.load_scene("res://Scenes/Levels/Home.tscn")
		"settings":
			$AudioStreamPlayer.play()
			emit_signal("selection",sig)
			get_node("SettingsMenu").show()
			get_node("MainMenu").hide()
		"load_game":
			$AudioStreamPlayer.play()
			emit_signal("selection",sig)
			#print(sig)
		"main_menu":
			$AudioStreamPlayer.play()
			emit_signal("selection",sig)
			get_node("SettingsMenu").hide()
			get_node("MainMenu").show()
		"loaded":
			print(sig)
			get_node("Loading").hide()

func remove_old_scene(_new_scene):
	oldScene.queue_free()
	oldScene = _new_scene
	#oldScene.connect("intent",self,"_on_menu_signal")
	emit_signal("scene_changed")
