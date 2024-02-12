extends CanvasLayer

var player = null
var skill_system = null
var button = null

signal talent_chosen(skill_identifier)

# Called when the node enters the scene tree for the first time.
func _ready():
	self.player = owner.get_node("Player")
	self.skill_system = self.player.get_node("Weapon").get_node("SkillSystem")
	self.button = load("res://button.tscn")
	#self.display_options()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass#self.global_position = self.player.global_position

func display_options(options=["A", "B", "C"]):
	var gc = self.get_node("GridContainer")
	for option in options:
		var b = self.button.instantiate()
		b.text = option
		gc.add_child(b)
		b.talent_chosen.connect(self.on_talent_chosen)
	get_tree().paused = true
		
func on_talent_chosen(skill_identifier):
	get_tree().paused = false
	var gc = self.get_node("GridContainer")
	for n in gc.get_children():
		gc.remove_child(n)
		n.queue_free()
	talent_chosen.emit(skill_identifier)


	
