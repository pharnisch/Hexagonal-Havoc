extends Button

var toggle_time = 0.5
var toggle_timer = 0.5
var paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	self.pressed.connect(self.toggle)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if toggle_timer >= toggle_time: 
		if Input.is_key_pressed(KEY_ENTER):
			self.toggle()
	else:
		toggle_timer += delta
	
func toggle():
	if get_tree().paused and !self.paused:
		return
	if toggle_timer >= toggle_time: 
		self.toggle_timer -= toggle_time
		get_tree().paused = !get_tree().paused
		self.paused = !self.paused
	
