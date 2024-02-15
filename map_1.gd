extends Node2D

var hexagon_enemy = null
var wave_timer = 0
var wave_time = 0
var wave_ind = 0
var walking_variant = 1
var walking_variants = 2
var rng = null
var waves = null
var agony = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	self.hexagon_enemy = load("res://hexagon_enemy_i.tscn")
	self.rng = RandomNumberGenerator.new()
	self.waves = [self.get_new_wave()]
	
	self.wave_time = self.waves[self.wave_ind]["duration"]
	self.wave_timer = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	self.wave_timer += delta
	if self.wave_timer >= self.wave_time:
		self.waves.append(self.get_new_wave())
		self.wave_ind += 1
		if wave_ind == self.waves.size():
			# game end (?)
			# repeat from start
			self.wave_ind = 0
			print("all waves finished")
		self.wave_time = self.waves[self.wave_ind]["duration"]
		self.wave_timer = 0
	
	var wave_ind = 0
	for sub_wave in self.waves[self.wave_ind]["sub_waves"]:
		if "spawned" not in sub_wave and sub_wave["spawn_time"] <= self.wave_timer:
			self.waves[self.wave_ind]["sub_waves"][wave_ind]["spawned"] = true
			var spawn_positions = sub_wave["shape"].call(sub_wave["amount"], sub_wave["shape_args"])
			for sp in spawn_positions:
				var new_enemy = sub_wave["enemy_type"].instantiate()
				new_enemy.walking_variant = sub_wave["walking_variant"]
				new_enemy.melee_dmg *= (1 + (sub_wave["difficulty_scale"] - 1)/ 1.)
				new_enemy.exp_worth *= (1 + (sub_wave["difficulty_scale"] - 1)/ 1.5)
				new_enemy.movement_speed_factor *= (1 + (sub_wave["difficulty_scale"] - 1)/ 8.)
				
				new_enemy.position = sp
				self.add_child(new_enemy)
				new_enemy.set_owner(self)
				new_enemy.get_node("HealthPool").health *= (1 + (sub_wave["difficulty_scale"] - 1)/ 1.)
				new_enemy.get_node("HealthPool").max_health *= (1 + (sub_wave["difficulty_scale"] - 1)/ 1.)
		wave_ind += 1

func square_wave(amount, shape_args):
	var possible_spawn_locations = []
	var amount_per_side = round(2 * shape_args["radius"] / shape_args["sep"])
	var pp = self.get_node("Player").global_position
	for i in range(amount_per_side):
			for j in [-shape_args["radius"], shape_args["radius"]]:
				for k in [true, false]:
					if k:
						possible_spawn_locations.append(Vector2(pp.x+shape_args["radius"]-i*shape_args["sep"],pp.y+j))
					else:
						possible_spawn_locations.append(Vector2(pp.x+j,pp.y+shape_args["radius"]-i*shape_args["sep"]))	
	return self.choose_locations(possible_spawn_locations, amount)
	
func circle_wave(amount, shape_args):
	var possible_spawn_locations = []
	var pp = self.get_node("Player").global_position
	for i in range(50):
		var rand_v = Vector2(self.rng.randf_range(-1,1), self.rng.randf_range(-1,1)).normalized() * shape_args["radius"]
		possible_spawn_locations.append(Vector2(pp.x+rand_v.x,pp.y+rand_v.y))
	return self.choose_locations(possible_spawn_locations, amount)

func choose_locations(locations, amount):
	var chosen_locations = []
	for i in range(amount):
		if locations.size() == 0:
			return chosen_locations
		var rnd_ind = self.rng.randi_range(0, locations.size() - 1)
		chosen_locations.append(locations[rnd_ind])
		locations.remove_at(rnd_ind)
	return chosen_locations
	
func get_new_wave():
	var hp = get_node("Player").get_node("HealthPool")
	var player_skill_estimate = hp.health/hp.max_health #(hp.health/hp.max_health + self.agony) / 2.
	var duration = 5 #self.rng.randi_range(5,20)
	var shapes = [self.square_wave, self.circle_wave]
	var difficulty_coefficient = 1 + wave_ind * 0.075 + wave_ind * 0.01 * (1 + player_skill_estimate)
	print("difficulty: ", difficulty_coefficient)
	var new_wave = {
		"duration": duration,
			"sub_waves": [
				{
					"spawn_time": 0,
					"enemy_type": self.hexagon_enemy,
					"amount": 2 + round(difficulty_coefficient),
					"shape": shapes[self.rng.randi_range(0,shapes.size()-1)],
					"shape_args": {"radius":600,"sep":100},
					"walking_variant": self.rng.randi_range(1,4),
					"difficulty_scale": difficulty_coefficient
				},
		],
	}
	return new_wave
		
func get_some_waves():
	return [
		{
			"duration": 5,
			"sub_waves": [
				{
					"spawn_time": 0,
					"enemy_type": self.hexagon_enemy,
					"amount": 5,
					"shape": self.circle_wave,
					"shape_args": {"radius":300,"sep":100},
					"walking_variant": 4,
				},
				{
					"spawn_time": 3,
					"enemy_type": self.hexagon_enemy,
					"amount": 5,
					"shape": self.circle_wave,
					"shape_args": {"radius":500,"sep":100},
					"walking_variant": 1,
				}
			],
		},
		{
			"duration": 5,
			"sub_waves": [
				{
					"spawn_time": 0,
					"enemy_type": self.hexagon_enemy,
					"amount": 5,
					"shape": self.square_wave,
					"shape_args": {"radius":600,"sep":100},
					"walking_variant": 3,
				},
				{
					"spawn_time": 3,
					"enemy_type": self.hexagon_enemy,
					"amount": 5,
					"shape": self.square_wave,
					"shape_args": {"radius":600,"sep":100},
					"walking_variant": 2,
				}
			],
		}
	]
