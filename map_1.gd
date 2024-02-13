extends Node2D

var hexagon_enemy = null
var wave_timer = 0
var wave_time = 0
var wave_ind = 0
var walking_variant = 1
var walking_variants = 2
var rng = null
var waves = null

# Called when the node enters the scene tree for the first time.
func _ready():
	self.hexagon_enemy = load("res://hexagon_enemy_i.tscn")
	self.rng = RandomNumberGenerator.new()
	self.waves = [
		{
			"duration": 5,
			"sub_waves": [
				{
					"spawn_time": 0,
					"enemy_type": self.hexagon_enemy,
					"amount": 5,
					"shape": self.circle_wave,
					"shape_args": {"radius":300,"sep":100},
					"walking_variant": 1,
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
					"walking_variant": 1,
				},
				{
					"spawn_time": 3,
					"enemy_type": self.hexagon_enemy,
					"amount": 5,
					"shape": self.square_wave,
					"shape_args": {"radius":600,"sep":100},
					"walking_variant": 1,
				}
			],
		}
	]
	
	self.wave_time = self.waves[self.wave_ind]["duration"]
	self.wave_timer = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	self.wave_timer += delta
	if self.wave_timer >= self.wave_time:
		self.wave_ind += 1
		if wave_ind == self.waves.size():
			# game end (?)
			# repeat from start
			self.wave_ind = 0
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
				new_enemy.position = sp
				self.add_child(new_enemy)
				new_enemy.set_owner(self)
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
