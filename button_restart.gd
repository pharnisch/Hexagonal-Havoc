extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	self.pressed.connect(click)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass

func click():
	#get_tree().reload_scene()
	#get_tree().change_scene("res://map_1.tscn")
	get_node("/root/Map_1").free()
	get_tree().change_scene_to_file("res://map_1.tscn")
