extends RigidBody

var image_path
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var material = SpatialMaterial.new()
	var img = Image.new()
	var imgTexture = ImageTexture.new()
	var file = File.new()
	file.open(image_path, File.READ)
	var data = file.get_buffer(file.get_len())
	file.close()
	var image_size = Vector2(0,0)
	var default_size = Vector2(1024,768)
	var image_ratio:float  
	if  image_path.split(".")[-1] == "png":
		img.load_png_from_buffer(data)
		image_size = img.get_size()
		image_ratio = float(image_size.x)/float(image_size.y)
		img.resize(default_size.y * image_ratio,default_size.y)
		imgTexture.create_from_image(img)
	else:
		img.load_jpg_from_buffer(data)
		image_size = img.get_size()
		image_ratio = float(image_size.x)/float(image_size.y)
		img.resize(default_size.y * image_ratio,default_size.y)
		imgTexture.create_from_image(img)
							
	if image_ratio > 1:
		scale.x += image_ratio

		
	material.albedo_texture = imgTexture
	$Cube011.set_surface_material(0,material)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
