extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var location = "main"

# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().connect("selection",self,"_on_selection")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_selection(selection):
	print(selection)
	match selection:
		"settings":
			$AnimationPlayer.play("Settings")
		"main_menu":
			if location == "Settings":
				$AnimationPlayer.play_backwards("Settings")
			elif location == "LoadGame":
				$AnimationPlayer.play_backwards("LoadGame")
			location = "main"
		"load_game":
			$AnimationPlayer.play("LoadGame")


func _on_AnimationPlayer_animation_finished(anim_name):
	location = anim_name
	pass # Replace with function body.
