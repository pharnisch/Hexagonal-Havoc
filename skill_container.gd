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
	var gc = self.get_node("Container").get_node("GridContainer")
	for option in options:
		var b = self.button.instantiate()
		b.text = get_description(option)
		b.identifier = option
		gc.add_child(b)
		b.talent_chosen.connect(self.on_talent_chosen)
	self.get_node("AnimationPlayer").play("UI_animation_test")
	get_tree().paused = true
		
func on_talent_chosen(skill_identifier):
	self.get_node("AnimationPlayer").play("CloseSkillBox")
	await get_tree().create_timer(0.7).timeout
	var gc = self.get_node("Container").get_node("GridContainer")
	for n in gc.get_children():
		gc.remove_child(n)
		n.queue_free()
	talent_chosen.emit(skill_identifier)
	
	get_tree().paused = false


func get_description(identifier):
	var descriptions =  {
		running_speed = "+10% Walking Speed",
		life_max = "+10 Max Life",
		life_reg = "+0.1 Life Per Second",
		
		# wird addiert zum spezialisierten, daher können diese up to 10 gehen (statt up to 5)!
		casting_speed = "3.3% Casting Speed",
		damage = "+3.3% Damage",
		crit = "+5% Crit Chance",
		crit_factor = "+5% Crit Multiplicator",
		living_time = "+3.3% Bullet Living Time",
		#ultimate_proc = 0,
		
		circle = {
			learned = "New Weapon: CIRCLE",
			
			casting_speed = "+10% Casting Speed [CIRCLE]",
			damage = "+10% Damage [CIRCLE]",
			crit = "+12.5% Crit Chance [CIRCLE]",
			crit_factor = "+12.5% Crit Multiplicator [CIRCLE]",
			living_time = "+10% Bullet Living Time [CIRCLE]",
			#ultimate_proc = 0,

			#travel_speed = 500,
			indestructable = "Bullets Are Not Consumed [CIRCLE]",
			#growing_speed = 0.05,
			attack_range = "+20% Attack Range [CIRCLE]",
			bounce = "+10% Bounce Chance [CIRCLE]",
			split = "+1 Split Bullet [CIRCLE]",
			
			#element = null,
		},
		line = {
			learned = "New Weapon: LINE",
			
			casting_speed = "+10% Casting Speed [LINE]",
			damage = "+10% Damage [LINE]",
			crit = "+12.5% Crit Chance [LINE]",
			crit_factor = "+12.5% Crit Multiplicator [LINE]",
			living_time = "+10% Bullet Living Time [LINE]",
			#ultimate_proc = 0,
			
			indestructable = "Bullets Are Not Consumed [LINE]",
			overshoot = "+25% Beam Length [LINE]", # todo: make main line longer (maximum 3 times long)
			sun_beam = "+2.5% Sun Beam Proc Chance [LINE]",
			attack_range = "+20% Attack Range [LINE]", # todo: create second attack range
			
			#element = null,
		},
		triangle = {
			learned = "New Weapon: TRIANGLE",
			
			casting_speed = "+10% Casting Speed [TRIANGLE]",
			damage = "+10% Damage [TRIANGLE]",
			crit = "+12.5% Crit Chance [TRIANGLE]",
			crit_factor = "+12.5% Crit Multiplicator [TRIANGLE]",
			living_time = "+10% Bullet Living Time [TRIANGLE]",
			#ultimate_proc = 0,
			
			rotation_speed = "+10% Rotation Speed [TRIANGLE]",
			growing_speed = "+10% Growing Speed [TRIANGLE]",
			growing_min_scale = "+10% Minimum Size [TRIANGLE]",
			growing_max_scale = "+10% Maximum Size [TRIANGLE]",
			
			#element = null,
		},
		square = {
			learned = "New Weapon: SQUARE",
			
			casting_speed = "+10% Casting Speed [SQUARE]",
			damage = "+10% Damage [SQUARE]",
			crit = "+12.5% Crit Chance [SQUARE]",
			crit_factor = "+12.5% Crit Multiplicator [SQUARE]",
			living_time = "+10% Bullet Living Time [SQUARE]",
			#ultimate_proc = 0,
			
			#travel_speed = 500,
			rotation_speed = "+10% Rotation Speed [SQUARE]",
			growing_speed = "+10% Growing Speed [SQUARE]",
			echo = "+1 Echo [SQUARE]",
			
			#element = null,
		},
	}
	if ":" in identifier:
		var spl = identifier.split(":")
		return descriptions[spl[0]][spl[1]]
	else:
		return descriptions[identifier]
	


	
