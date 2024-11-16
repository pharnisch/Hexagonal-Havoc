extends Button

#var level = preload("res://map_1.tscn")
@export var level = 1
@export var sel = false

var sound_player = null
var choose_sound = null
var select_sound = null

# Called when the node enters the scene tree for the first time.
func _ready():
	self.pressed.connect(self.on_pressed)
	self.connect("focus_entered", Callable(self, "_on_focus_entered"))
	if self.sel:
		self.grab_focus()
		
	if sound_player == null:
		sound_player = get_parent().get_parent().get_parent().get_node("SoundPlayer")
		choose_sound = preload("res://hexagon_assets/menuchoose.wav")
		select_sound = preload("res://hexagon_assets/menuselect.wav")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_pressed():
	#get_tree().change_scene_to_packed(load("res://map_1.tscn"))
	#if sound_player != null:
#		sound_player.stream = select_sound
#		sound_player.play()
	#print(get_tree().paused)
	get_tree().change_scene_to_packed(load("res://map_" + str(self.level) + ".tscn"))

func _on_focus_entered():
	if sound_player != null:
		sound_player.stream = choose_sound
		sound_player.play()
