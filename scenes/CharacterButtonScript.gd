extends TextureButton



func _ready():
	self.connect("pressed", self, "_button_pressed")



func _button_pressed():
	print("Hello world!")
	var d = Directory.new()
	d.change_dir(self.texture_normal.resource_path)
	print(d.get_current_dir())
