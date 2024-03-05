extends Button

#var level = preload("res://map_1.tscn")

@export var scene_name = "map_1"

# Called when the node enters the scene tree for the first time.
func _ready():
	self.pressed.connect(click)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_ESCAPE):
		self.click()

func click():
	#get_node("/root/Map_1").free()
	#get_tree().change_scene_to_file("res://map_1.tscn")
	print(get_tree().paused)
	get_tree().change_scene_to_packed(load("res://"+self.scene_name+".tscn"))
	#get_tree().change_scene_to_packed(load("res://home.tscn"))

	#get_tree().reload_current_scene()
