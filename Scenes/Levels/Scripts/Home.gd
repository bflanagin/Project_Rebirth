extends Spatial

#signal loaded()
#signal intent(action)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var base = load("res://Scenes/Levels/House1.tscn").instance()
var player = load("res://Scenes/Models/Player/Player.tscn").instance()
var fileItem = load("res://Scenes/Models/Misc/Paper.tscn")
var dirItem = load("res://Scenes/Models/Misc/CardBoardBox.tscn")
var imgItem = load("res://Scenes/Models/Misc/Photo.tscn")
var musicItem = load("res://Scenes/Models/Misc/JewelCase.tscn")
var albumItem = load("res://Scenes/Models/Misc/PhotoAlbum.tscn")
#var playerInstance = player.instance()
# Called when the node enters the scene tree for the first time.
func _ready():
	#var playarea = base.instance()
	base.add_child(player)
	player.translation = base.get_node("spawnpoint").translation
	player.connect("action",self,"_on_player_action")
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
		dir.list_dir_begin(true,true)
		var file_name = dir.get_next()
		while file_name != "":
			var base_floor = base.get_node("Floor/Area/CollisionShape")
			randomize()
			var rand_x = rand_range(-base_floor.shape.extents.x * 0.7,base_floor.shape.extents.x * 0.7)
			randomize()
			var rand_z = rand_range(-base_floor.shape.extents.z * 0.7,base_floor.shape.extents.z * 0.7)
			randomize()
			var rand_y = rand_range(-base_floor.shape.extents.y * 0.99,base_floor.shape.extents.y * 0.1)
			var finalLocation = base_floor.translation 
			finalLocation.x += rand_x 
			finalLocation.y = base.get_node("Floor").translation.y +1.1
			finalLocation.z += rand_z
			if dir.current_is_dir():
				if file_name in ["Music","Videos","Documents","Pictures"]:
					match file_name:
						"Music":
							music_files(path+"/"+file_name,OU)
						"Pictures":
							picture_files(path+"/"+file_name,OU)
						"Videos":
							video_files(path+"/"+file_name,OU)
						_:
							var dirInstance = dirItem.instance()
							OU.call_deferred("add_child",dirInstance)
							dirInstance.translation = Vector3(finalLocation.x,1,finalLocation.y)
				#else:
				#	var dirInstance = dirItem.instance()
				#	OU.call_deferred("add_child",dirInstance)
				#	dirInstance.translation = Vector3(finalLocation.x,1,finalLocation.y)
			else:
				#print (file_name.split(".")[-1])
				match file_name.split(".")[-1]:
					"txt","doc","docx","odt","xml","csv":
						var fileInstance = fileItem.instance()
						OU.call_deferred("add_child",fileInstance)
						fileInstance.translation = finalLocation
					"png","jpg","jpeg":
						var imageInstance = imgItem.instance()
						imageInstance.image_path = path+"/"+file_name
						OU.call_deferred("add_child",imageInstance)
						imageInstance.translation = finalLocation
				
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

	pass

func orgainized_things():
	pass

func music_files(path,parent):
	#print(path)
	var Item = load("res://Scenes/Models/Misc/CDBox.tscn")
	var dir = Directory.new()
	if dir.open(path) == OK:
		var base_floor = base.get_node("Floor/Area/CollisionShape")
		var dirnum = 0
		dir.list_dir_begin(true,true)
		var file_name = dir.get_next()
		while file_name != "":
			randomize()
			var rand_x = rand_range(-base_floor.shape.extents.x * 0.7,base_floor.shape.extents.x * 0.7)
			randomize()
			var rand_z = rand_range(-base_floor.shape.extents.z * 0.5,base_floor.shape.extents.z * 0.5)
			randomize()
			var rand_y = rand_range(-base_floor.shape.extents.y * 0.99,base_floor.shape.extents.y * 0.1)
			var finalLocation = base_floor.translation 
			finalLocation.x += rand_x 
			finalLocation.y = base.get_node("Floor").translation.y + 0.5
			finalLocation.z += rand_z
			var Instance = Item.instance()
			if dir.current_is_dir():
				if !Mistro.big_list.has("Music"):
					Mistro.big_list["Music"] = {}
				if !Mistro.big_list["Music"].has(file_name):
					Mistro.big_list["Music"][file_name] = {}
				Mistro.recursive_search(path+"/"+file_name,Mistro.big_list["Music"][file_name])
				#print(Mistro.big_list)
				if dirnum % 25 == 0:
					parent.add_child(Instance)
					Instance.translation = finalLocation
				dirnum += 1
			file_name = dir.get_next()
		#print(Mistro.big_list["Music"].keys())
		if Mistro.big_list.has("Music"):
			for artist in Mistro.big_list["Music"].keys():
				for album in Mistro.big_list["Music"][artist]:
					var aInstance = musicItem.instance()
					randomize()
					var a_rand_x = rand_range(-base_floor.shape.extents.x * 0.7,base_floor.shape.extents.x * 0.7)
					randomize()
					var a_rand_z = rand_range(-base_floor.shape.extents.z * 0.5,base_floor.shape.extents.z * 0.5)
					randomize()
					var a_rand_y = rand_range(-base_floor.shape.extents.y * 0.99,base_floor.shape.extents.y * 0.1)
					var a_finalLocation = base_floor.translation 
					a_finalLocation.x += a_rand_x 
					a_finalLocation.y = base.get_node("Floor").translation.y + 0.5
					a_finalLocation.z += a_rand_z
					aInstance.translation = a_finalLocation
					aInstance.url = album
					parent.add_child(aInstance)
					#print(finalLocation)
				
				
		#play_mp3(Mistro.big_list["Music"]["christafari"]["wordsoundpower"]["songs"][0]["url"])
	else:
		print("An error occurred when trying to access the path.")

func picture_files(path,parent):
	if !Mistro.big_list.has("Pictures"):
		Mistro.big_list["Pictures"] = {}
	Mistro.recursive_search(path,Mistro.big_list["Pictures"])
	var base_floor = base.get_node("Floor/Area/CollisionShape")
	for album in Mistro.big_list["Pictures"].keys():
		var aInstance = albumItem.instance()
		randomize()
		var a_rand_x = rand_range(-base_floor.shape.extents.x * 0.7,base_floor.shape.extents.x * 0.7)
		randomize()
		var a_rand_z = rand_range(-base_floor.shape.extents.z * 0.5,base_floor.shape.extents.z * 0.5)
		randomize()
		var a_rand_y = rand_range(-base_floor.shape.extents.y * 0.99,base_floor.shape.extents.y * 0.1)
		var a_finalLocation = base_floor.translation 
		a_finalLocation.x += a_rand_x 
		a_finalLocation.y = base.get_node("Floor").translation.y + 0.5
		a_finalLocation.z += a_rand_z
		aInstance.translation = a_finalLocation
		aInstance.url = album
		parent.add_child(aInstance)
	pass

func video_files(path,parent):
	pass

func _on_player_action(action,target):
	match action:
		"play":
			print("Action engaged: Play")
			#play_album(target)
		"inspect":
			print(target.name)
