extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func play_mp3(url):
	
	$AudioStreamPlayer.stop()
	var playmp3 = AudioStreamMP3.new()
	var file = File.new()
	file.open(url,File.READ)
	playmp3.set_data(file.get_buffer(file.get_len()))
	$AudioStreamPlayer.stream = playmp3
	$AudioStreamPlayer.play()

func play_album(url):
	var list = Mistro.big_list["Music"]
	for artist in list.keys():
		for album in Mistro.big_list["Music"][artist]:
			if url == album:
				#print("found album")
				for song in Mistro.big_list["Music"][artist][album]["songs"]:
					if !$AudioStreamPlayer.playing:
						print(song["title"])
						play_mp3(song["url"])
