extends GridContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$HBoxContainer/VBoxContainer/VBoxContainer/Master/MasterVolume.value = AudioServer.get_bus_volume_db(0)
	$HBoxContainer/VBoxContainer/VBoxContainer/Music/MusicVolume.value = AudioServer.get_bus_volume_db(1)
	$HBoxContainer/VBoxContainer/VBoxContainer/SFX/SFXVolume.value = AudioServer.get_bus_volume_db(2)
	rect_min_size = get_parent().rect_size
	#load_sound_devices()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_SFXVolume_value_changed(value):
	AudioServer.set_bus_volume_db(2,value)
	pass # Replace with function body.


func _on_MusicToggle_toggled(button_pressed):
	if button_pressed:
		AudioServer.set_bus_mute(1,false)
	else:
		AudioServer.set_bus_mute(1,true)
	pass # Replace with function body.

func _on_MusicVolume_value_changed(value):
	AudioServer.set_bus_volume_db(1,value)
	pass # Replace with function body.


func _on_SFXToggle_toggled(button_pressed):
	if button_pressed:
		AudioServer.set_bus_mute(2,false)
	else:
		AudioServer.set_bus_mute(2,true)
	pass # Replace with function body.


func _on_MasterToggle_toggled(button_pressed):
	if button_pressed:
		AudioServer.set_bus_mute(0,false)
	else:
		AudioServer.set_bus_mute(0,true)
	pass # Replace with function body.


func _on_MasterVolume_value_changed(value):
	AudioServer.set_bus_volume_db(0,value)
	pass # Replace with function body.

func load_sound_devices():
	for device in AudioServer.get_device_list():
		var chbx = CheckButton.new()
		chbx.name = str(device)
		chbx.text = str(device).split(".")
		chbx.flat = true
		chbx.focus_mode = FOCUS_NONE
		$HBoxContainer2/VBoxContainer.add_child(chbx)
