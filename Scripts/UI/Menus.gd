extends PanelContainer


#signal play()
#signal load_game()
#signal quit_game()
#signal settings()
signal intent(action)
var submenus = []

# Called when the node enters the scene tree for the first time.
func _ready():
	find_buttons()
	location_settings()
	if get_parent().name == "SettingsMenu":
		var sound = load("res://Scenes/UI/Elements/Settings/Sound.tscn")
		var linked = load("res://Scenes/UI/Elements/Settings/LinkedAccounts.tscn")
		var graphics = load("res://Scenes/UI/Elements/Settings/Graphics.tscn")
		var display = load("res://Scenes/UI/Elements/Settings/Display.tscn")
		submenus = [display.instance(),graphics.instance(),linked.instance(),sound.instance()]
		$HSplitContainer/SettingsPane.add_child(submenus[0])
	#$VBoxContainer/TextureRect/Title.text = get_node("../../").appname
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	location_settings()
	
	pass

func find_buttons():
	for child in get_children():
		if child.get_child_count() > 0:
			for grandchild in child.get_children():
				if grandchild.get_child_count() > 0:
					for greatgrandchild in grandchild.get_children():
						find_button(greatgrandchild)
				else:
					find_button(grandchild)
		else:
			find_button(child)

func find_button(button):
	if button is Button:
		#if button.name in ["Play","Load","Quit","Back","Settings"]:
		button.connect("pressed",self,"_on_pressed",[button.name])
			
func _on_pressed(name):
	match name:
		"Play":
			emit_signal("intent","play")
		"Load":
			emit_signal("intent","load_game")
		"Quit":
			emit_signal("intent","quit_game")
		"Back":
			#print("Back Pressed, sending main_menu")
			emit_signal("intent","main_menu")
		"Settings":
			emit_signal("intent","settings")
		"Sound":
			show_submenu(name)
		"Display":
			show_submenu(name)
		"Graphics":
			show_submenu(name)
		"LinkedAccounts":
			show_submenu(name)

func location_settings():
	var windowSize = OS.window_size
	match name:
		"CenterMenu":
			get_child(0).rect_min_size.y = windowSize.y * 0.8
			get_child(0).rect_size.y = windowSize.y * 0.8
			get_child(0).rect_min_size.x = windowSize.x * 0.7
			get_child(0).rect_size.x = windowSize.x * 0.7
			set_anchors_and_margins_preset(Control.PRESET_CENTER)
		"RightMenu":
			set_anchors_and_margins_preset(Control.PRESET_RIGHT_WIDE)
			get_child(0).rect_min_size.x = windowSize.x * 0.20
			get_child(0).rect_size.x = windowSize.x * 0.20
			
		"LeftMenu":
			set_anchors_and_margins_preset(Control.PRESET_LEFT_WIDE)
			get_child(0).rect_min_size.x = windowSize.x * 0.20
			get_child(0).rect_size.x = windowSize.x * 0.20
		"FullMenu":
			set_anchors_and_margins_preset(Control.PRESET_WIDE)
			get_child(0).rect_min_size.y = windowSize.y * 0.9
			get_child(0).rect_size.y = windowSize.y * 0.9
			get_child(0).rect_min_size.x = windowSize.x * 0.9
			get_child(0).rect_size.x = windowSize.x * 0.9
		
	if get_parent().name == "SettingsMenu":
		$HSplitContainer/options.rect_min_size.x =$HSplitContainer.rect_size.x * 0.2
		$HSplitContainer/options.rect_size.x = $HSplitContainer.rect_size.x * 0.2
			
func show_submenu(menu):
	#print("Looking for submenu ",menu)
	for child in $HSplitContainer/SettingsPane.get_children():
		$HSplitContainer/SettingsPane.remove_child(child)
	for obj in submenus:
		if obj.name == menu:
			$HSplitContainer/SettingsPane.add_child(obj)
			break;
		
	pass
