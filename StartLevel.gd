extends Button

#var level = preload("res://map_1.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	self.pressed.connect(self.on_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_pressed():
	#get_tree().change_scene_to_packed(load("res://map_1.tscn"))
	print(get_tree().paused)
	get_tree().change_scene_to_packed(load("res://map_1.tscn"))
