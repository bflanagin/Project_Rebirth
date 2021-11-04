extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var appname = "game"
signal selection(sig)
# Called when the node enters the scene tree for the first time.
func _ready():
	_on_first_load()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# This loads the first scenes needed to create a game. 
func _on_first_load():
	appname = "V0.01"
	var attract = load("res://Scenes/Levels/Attract.tscn")
	var mainMenu = load("res://Scenes/UI/MainMenu.tscn")
	var settingsMenu = load("res://Scenes/UI/SettingsMenu.tscn")
	var attractInstance = attract.instance()
	var mainMenuInstance = mainMenu.instance()
	var settingsMenuInstance = settingsMenu.instance()
	settingsMenuInstance.menuType = "CenterMenu"
	
	mainMenuInstance.menuType = "LeftMenu"
	add_child(mainMenuInstance)
	add_child(settingsMenuInstance)
	add_child(attractInstance)
	
	mainMenuInstance.connect("intent",self,"_on_menu_signal")
	settingsMenuInstance.connect("intent",self,"_on_menu_signal")
	get_node("SettingsMenu").hide()
	

func _on_menu_signal(sig):
	print(sig)
	match sig:
		"quit_game":
			$AudioStreamPlayer.play()
			get_tree().quit()
		"play":
			$AudioStreamPlayer.play()
			print(sig)
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
