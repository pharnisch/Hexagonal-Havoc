extends Node

signal skills_updated(new_state)

var state = null
var timer = 0
var updated = false

# Called when the node enters the scene tree for the first time.
func _ready():
	self.state = self.get_default_state()
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
	if self.timer >= 2 and not self.updated:
		self.update()
		self.updated = true
	
func update():
	skills_updated.emit(self.state)

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
			destructable = true,
			#growing_speed = 0.05,
			attack_range = 0,
			
			element = null,
		},
		line = {
			learned = false,
			
			casting_speed = 0,
			damage = 0,
			crit = 0,
			crit_factor = 0,
			living_time = 0,
			#ultimate_proc = 0,
			
			destructable = true,
			overshoot = 0, # todo: make main line longer (maximum 3 times long)
			sun_beam = 0,
			attack_range = 0, # todo: create second attack range
			
			element = null,
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
			growing_min_scale = 0,
			growing_max_scale = 0,
			
			element = null,
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
			rotation_speed = 0,
			growing_speed = 0,
			
			element = null,
		},
	}
	
func get_max_state():
	return {
		running_speed = 0,
		life_max = 0,
		life_reg = 0,
		
		# wird addiert zum spezialisierten, daher können diese up to 10 gehen (statt up to 5)!
		casting_speed = 5,
		damage = 20,
		crit = 5,
		crit_factor = 5,
		living_time = 5,
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
			destructable = false,
			#growing_speed = 0.05,
			attack_range = 0,
			
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
			
			destructable = false,
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
			growing_min_scale = 5,
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
			rotation_speed = 5,
			growing_speed = 5,
			
			element = null,
		},
	}
