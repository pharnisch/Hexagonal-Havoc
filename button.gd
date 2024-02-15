extends Button

signal talent_chosen(skill_identifier)

var identifier = null

# Called when the node enters the scene tree for the first time.
func _ready():
	self.pressed.connect(self.on_click)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass

func on_click():
	talent_chosen.emit(self.identifier)
