extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	rect_min_size = get_parent().rect_size
	rect_size = get_parent().rect_size
	$HBoxContainer/VBoxContainer.rect_size = rect_size * 0.9
	$HBoxContainer/VBoxContainer.rect_min_size = rect_size * 0.9
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
