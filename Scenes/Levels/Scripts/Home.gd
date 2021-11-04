extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var base = load("res://Scenes/Levels/House1.tscn")
var player = load("res://Scenes/Models/Player/Player.tscn")
var playerInstance = player.instance()
# Called when the node enters the scene tree for the first time.
func _ready():
	var playarea = base.instance()
	playarea.add_child(playerInstance)
	playerInstance.translation = playarea.get_node("spawnpoint").translation
	add_child(playarea)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
