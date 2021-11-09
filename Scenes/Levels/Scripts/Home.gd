extends Spatial

#signal loaded()
#signal intent(action)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var base = load("res://Scenes/Levels/House1.tscn").instance()
var player = load("res://Scenes/Models/Player/Player.tscn").instance()
var fileItem = load("res://Scenes/Models/Misc/FileItem.tscn")
var dirItem = load("res://Scenes/Models/Misc/DirItem.tscn")
#var playerInstance = player.instance()
# Called when the node enters the scene tree for the first time.
func _ready():
	#var playarea = base.instance()
	base.add_child(player)
	player.translation = base.get_node("spawnpoint").translation
	add_child(base)
	gather_things()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func gather_things():
	var dir = Directory.new()
	var path = OS.get_environment("HOME")
	if dir.open(path) == OK:
		
		var OU = base.get_node("Files")
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			randomize()
			
			var base_floor = base.get_node("Floor")
			var possibleLocations = base_floor.mesh.get_faces()
			var randomLocation = int(rand_range(0,possibleLocations.size()))
			var finalLocation = possibleLocations[randomLocation] - Vector3(7,0,7)
			
			if dir.current_is_dir():
				var dirInstance = dirItem.instance()
				dirInstance.translation = Vector3(finalLocation.x,1,finalLocation.y)
				OU.call_deferred("add_child",dirInstance)
			else:
				var fileInstance = fileItem.instance()
				fileInstance.translation = Vector3(finalLocation.x,1,finalLocation.y)
				OU.call_deferred("add_child",fileInstance)	
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

	pass

func orgainized_things():
	pass
	
