extends Button

signal talent_chosen(skill_identifier)

# Called when the node enters the scene tree for the first time.
func _ready():
	self.pressed.connect(self.on_click)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_click():
	talent_chosen.emit(self.text)
