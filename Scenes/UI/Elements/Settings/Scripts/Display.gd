extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	custom_minimum_size = get_parent().size
	size = get_parent().size
	$HBoxContainer/VBoxContainer.size = size * 0.9
	$HBoxContainer/VBoxContainer.custom_minimum_size = size * 0.9
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
