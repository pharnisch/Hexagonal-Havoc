extends Node

signal skills_updated(new_state)

var state = null
var timer = 0
var updated = false
var rng = null
var skill_container = null
var skill_points_spent = 0
var offer_skill_upgrades_active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	self.rng = RandomNumberGenerator.new()
	self.state = self.get_default_state()
	self.skill_container = owner.owner.owner.get_node("SkillContainer")
	self.skill_container.talent_chosen.connect(on_talent_chosen)
	#self.state.line.learned = true
	#self.state.circle.learned = true
	#self.state.triangle.learned = true
	#self.state.square.learned = true
	#self.state = self.get_max_state()
	#self.state.triangle.learned = false
	#self.state.square.learned = false
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.timer += delta
	if self.timer >= 0.01 and not self.updated:
		#self.offer_skill_upgrades()
		self.updated = true
		self.update()
	
func update():
	skills_updated.emit(self.state)

func get_random_skill_options(n):
	var all_options = []
	for k_i in self.state.keys():
		if (typeof(self.state[k_i]) != typeof({})):
			if self.state[k_i] < 10 or (k_i == "damage" and self.state[k_i] < 20):
				all_options.append(k_i)
		else:
			for k_j in self.state[k_i].keys():
				if (typeof(self.state[k_i][k_j]) != typeof(true)) and ((self.state[k_i][k_j]) != (null)) and (typeof(self.state[k_i][k_j]) != typeof({})):
					if self.state[k_i][k_j] < 5 or (k_j == "damage" and self.state[k_i][k_j] < 20):
						if self.state[k_i].learned:
							all_options.append(k_i + ":" + k_j)
	#print(all_options)
	var selected = []
	for i in range(n):
		var rand_ind = self.rng.randi_range(0, all_options.size() - 1)
		if rand_ind == -1 or all_options.size() == 0:
			break
		selected.append(all_options[rand_ind])
		all_options.remove_at(rand_ind)
	return selected

func get_random_big_skill_options(n):
	var all_options = []
	for k_i in self.state.keys():
		if (typeof(self.state[k_i]) == typeof({})):
			for k_j in self.state[k_i].keys():
				if (typeof(self.state[k_i][k_j]) == typeof(false) and (self.state[k_i][k_j]) == (false)) or ((self.state[k_i][k_j]) == (null)):
					#all_options.append(k_i + ":" + k_j)
					if k_j == "learned" or self.state[k_i].learned:
						all_options.append(k_i + ":" + k_j)

	var selected = []
	for i in range(n):
		var rand_ind = self.rng.randi_range(0, all_options.size() - 1)
		if rand_ind == -1 or all_options.size() == 0:
			break
		selected.append(all_options[rand_ind])
		all_options.remove_at(rand_ind)
	return selected

func on_talent_chosen(skill_identifier):
	if ":" in skill_identifier:
		var spl = skill_identifier.split(":")
		if typeof(self.state[spl[0]][spl[1]]) == typeof(0):
			self.state[spl[0]][spl[1]] += 1
		elif typeof(self.state[spl[0]][spl[1]]) == typeof(false):
			self.state[spl[0]][spl[1]] = true
		elif typeof(self.state[spl[0]][spl[1]]) == typeof(null):
			self.state[spl[0]][spl[1]] = {}
	else:
		self.state[skill_identifier] += 1
	self.offer_skill_upgrades_active = false
	self.update()
	#self.offer_skill_upgrades()

func offer_skill_upgrades():
	self.offer_skill_upgrades_active = true
	self.skill_points_spent += 1
	if self.skill_points_spent % 10 == 0:
		var options = self.get_random_big_skill_options(3)
		if options.size() == 0:
			var minor_options = self.get_random_skill_options(3)
			if minor_options.size() == 0:
				return
			self.skill_container.display_options(minor_options)
		else:
			self.skill_container.display_options(options)
	else:
		var minor_options = self.get_random_skill_options(3)
		if minor_options.size() == 0:
			return
		self.skill_container.display_options(minor_options)
		

# alles kann man 5 mal skillen (außer boolean), also einfach integer 0-5, das scaling mit basiswerten passiert dann bei der anwendung
func get_default_state():
	return {
		running_speed = 0,
		life_max = 0,
		life_reg = 0,
		
		# wird addiert zum spezialisierten, daher können diese up to 10 gehen (statt up to 5)!
		casting_speed = 0,
		damage = 0,
		crit = 0,
		crit_factor = 0,
		living_time = 0,
		#ultimate_proc = 0,
		
		circle = {
			learned = true,
			
			casting_speed = 0,
			damage = 0,
			crit = 0,
			crit_factor = 0,
			living_time = 0,
			#ultimate_proc = 0,

			#travel_speed = 500,
			indestructable = false,
			#growing_speed = 0.05,
			attack_range = 0,
			bounce = 0,
			split = 0,
			
			#element = null,
		},
		line = {
			learned = false,
			
			casting_speed = 0,
			damage = 0,
			crit = 0,
			crit_factor = 0,
			living_time = 0,
			#ultimate_proc = 0,
			
			indestructable = false,
			overshoot = 0, # todo: make main line longer (maximum 3 times long)
			sun_beam = 0,
			attack_range = 0, # todo: create second attack range
			
			#element = null,
		},
		triangle = {
			learned = false,
			
			casting_speed = 0,
			damage = 0,
			crit = 0,
			crit_factor = 0,
			living_time = 0,
			#ultimate_proc = 0,
			
			rotation_speed = 0,
			growing_speed = 0,
			#growing_min_scale = 0,
			growing_max_scale = 0,
			
			#element = null,
		},
		square = {
			learned = false,
			
			casting_speed = 0,
			damage = 0,
			crit = 0,
			crit_factor = 0,
			living_time = 0,
			#ultimate_proc = 0,
			
			#travel_speed = 500,
			#rotation_speed = 0,
			#growing_speed = 0,
			echo = 0,
			
			#element = null,
		},
	}
	
func get_max_state():
	return {
		running_speed = 10,
		life_max = 10,
		life_reg = 10,
		
		# wird addiert zum spezialisierten, daher können diese up to 10 gehen (statt up to 5)!
		casting_speed = 10,
		damage = 20,
		crit = 10,
		crit_factor = 10,
		living_time = 10,
		#ultimate_proc = 0,
		
		circle = {
			learned = true,
			
			casting_speed = 5,
			damage = 20,
			crit = 5,
			crit_factor = 5,
			living_time = 5,
			#ultimate_proc = 0,

			#travel_speed = 500,
			indestructable = true,
			#growing_speed = 0.05,
			attack_range = 0,
			bounce = 5,
			split = 5,
			
			element = null,
		},
		line = {
			learned = true,
			
			casting_speed = 5,
			damage = 20,
			crit = 5,
			crit_factor = 5,
			living_time = 5,
			#ultimate_proc = 0,
			
			indestructable = true,
			overshoot = 5, # todo: make main line longer (maximum 3 times long)
			sun_beam = 5,
			attack_range = 0, # todo: create second attack range
			
			element = null,
		},
		triangle = {
			learned = true,
			
			casting_speed = 5,
			damage = 5,
			crit = 5,
			crit_factor = 5,
			living_time = 5,
			#ultimate_proc = 0,
			
			rotation_speed = 5,
			growing_speed = 5,
			#growing_min_scale = 5,
			growing_max_scale = 5,
			
			element = null,
		},
		square = {
			learned = true,
			
			casting_speed = 5,
			damage = 5,
			crit = 5,
			crit_factor = 5,
			living_time = 5,
			#ultimate_proc = 0,
			
			#travel_speed = 500,
			#rotation_speed = 5,
			growing_speed = 5,
			echo = 5,
			
			element = null,
		},
	}
