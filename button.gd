extends Button

signal talent_chosen(skill_identifier)

var identifier = null

# Called when the node enters the scene tree for the first time.
func _ready():
	self.pressed.connect(self.on_click)
	self.random_skill_logic()
		


func physics(delta):
	#if self.has_focus():
	#	self.set("theme_override_constants/outline_size", 20)
	#	print("make big")
	#else:
	#	self.set("theme_override_constants/outline_size", 0)
	#self._draw()
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass

func on_click():
	talent_chosen.emit(self.identifier)
	
func random_skill_logic():
	if (get_tree().get_current_scene().name) == "Map_2":
		self.disabled = true
		await get_tree().create_timer(1, true).timeout
		self.on_click()
		get_parent().get_parent().get_parent().on_talent_chosen(self.identifier)
