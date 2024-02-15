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
		if "[" in b.text:
			var spl = b.text.split("[")
			b.text = spl[0]
			if "CIRCLE" in spl[1]:
				b.add_child(load("res://circle_decoration.tscn").instantiate())
			elif "LINE" in spl[1]:
				b.add_child(load("res://line_decoration.tscn").instantiate())
			elif "SQUARE" in spl[1]:
				b.add_child(load("res://square_decoration.tscn").instantiate())
			elif "TRIANGLE" in spl[1]:
				b.add_child(load("res://triangle_decoration.tscn").instantiate())
		
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
		running_speed = "+20% Walking Speed",
		life_max = "+50 Max Life",
		life_reg = "+0.5 Life Per Second",
		exp_bonus = "+10% EXP",
		
		# wird addiert zum spezialisierten, daher können diese up to 10 gehen (statt up to 5)!
		casting_speed = "3.3% Casting Speed",
		damage = "+3.3% Damage",
		crit = "+5% Crit Chance",
		crit_factor = "+10% Crit Multiplicator",
		living_time = "+12.5% Bullet Living Time",
		#ultimate_proc = 0,
		
		attack_range = "+10% Attack Range",
		
		circle = {
			learned = "New Weapon: CIRCLE [CIRCLE]",
			
			casting_speed = "+10% Casting Speed [CIRCLE]",
			damage = "+10% Damage [CIRCLE]",
			crit = "+12.5% Crit Chance [CIRCLE]",
			crit_factor = "+20% Crit Multiplicator [CIRCLE]",
			living_time = "+25% Bullet Living Time [CIRCLE]",
			#ultimate_proc = 0,

			#travel_speed = 500,
			indestructable = "+10% Penetration Bullets [CIRCLE]",
			#growing_speed = 0.05,
			attack_range = "+20% Attack Range [CIRCLE]",
			bounce = "+10% Bounce Chance [CIRCLE]",
			split = "+1 Split Bullet [CIRCLE]",
			
			#element = null,
		},
		line = {
			learned = "New Weapon: LINE [LINE]",
			
			casting_speed = "+10% Casting Speed [LINE]",
			damage = "+10% Damage [LINE]",
			crit = "+12.5% Crit Chance [LINE]",
			crit_factor = "+20% Crit Multiplicator [LINE]",
			living_time = "+25% Bullet Living Time [LINE]",
			#ultimate_proc = 0,
			
			indestructable = "+10% Penetration Bullets [LINE]",
			overshoot = "+25% Beam Length [LINE]", # todo: make main line longer (maximum 3 times long)
			sun_beam = "+2.5% Sun Beam Proc Chance [LINE]",
			attack_range = "+20% Attack Range [LINE]", # todo: create second attack range
			
			#element = null,
		},
		triangle = {
			learned = "New Weapon: TRIANGLE [TRIANGLE]",
			
			casting_speed = "+10% Casting Speed [TRIANGLE]",
			damage = "+10% Damage [TRIANGLE]",
			crit = "+12.5% Crit Chance [TRIANGLE]",
			crit_factor = "+20% Crit Multiplicator [TRIANGLE]",
			living_time = "+25% Bullet Living Time [TRIANGLE]",
			#ultimate_proc = 0,
			
			rotation_speed = "+33% Rotation Speed [TRIANGLE]",
			growing_speed = "+33% Growing Speed [TRIANGLE]",
			#growing_min_scale = "+10% Minimum Size [TRIANGLE]",
			growing_max_scale = "+33% Maximum Size [TRIANGLE]",
			surrounding = "+1 Surrounding [TRIANGLE]",
			
			#element = null,
		},
		square = {
			learned = "New Weapon: SQUARE [SQUARE]",
			
			casting_speed = "+10% Casting Speed [SQUARE]",
			damage = "+10% Damage [SQUARE]",
			crit = "+12.5% Crit Chance [SQUARE]",
			crit_factor = "+20% Crit Multiplicator [SQUARE]",
			living_time = "+25% Bullet Living Time [SQUARE]",
			#ultimate_proc = 0,
			
			#travel_speed = 500,
			#rotation_speed = "+10% Rotation Speed [SQUARE]",
			#growing_speed = "+10% Growing Speed [SQUARE]",
			echo = "+1 Echo [SQUARE]",
			collapsing = "+10% Collapsing [SQUARE]",
			stun_chance = "+15% Stun Chance [SQUARE]",
			stun_time = "+0.75s Stun Time [SQUARE]",
			#element = null,
		},
	}
	if ":" in identifier:
		var spl = identifier.split(":")
		return descriptions[spl[0]][spl[1]]
	else:
		return descriptions[identifier]
	


	
