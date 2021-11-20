extends RigidBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var url = ""
var copy_of = null
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func targeted(_by,currently):
	if currently == true:
		$Cube019/targeted.show()
	else:
		$Cube019/targeted.hide()

func picked_up(_by):
	#print("AAAWWWWW!!!!!")
	var copy = self.duplicate()
	copy.copy_of = self
	copy.mode = RigidBody.MODE_STATIC
	copy.get_node("CollisionShape").disabled = true
	self.hide()
	return self
