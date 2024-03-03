extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true) 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_SPACE):
		get_node("RestartButton").click()
	if Input.is_key_pressed(KEY_ESCAPE):
		get_node("HomeButton").click()
