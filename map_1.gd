extends Node2D

var enemy = null
var spawn_time = 15
var spawn_timer = 14
var walking_variant = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	self.enemy = load("res://hexagon_enemy_i.tscn")

	# randomize different walking strategies
	# randomize different comfort zone strategies (pause for x time, walk in opposite for x time, walk in random direction for x time)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.spawn_timer += delta
	if self.spawn_timer >= self.spawn_time:
		self.spawn_timer -= self.spawn_time
		
		# -500/(-400/.../0/.../400)  500/(-400/.../0/.../400)  (-400/.../0/.../400)/-500  (-400/.../0/.../400)/500
		for i in range(10):
			for j in [-600, 600]:
				for k in [true, false]:
					var new_enemy = self.enemy.instantiate()
					var pp = self.get_node("Player").global_position
					if k:
						new_enemy.position = Vector2(pp.x+400-i*100,pp.y+j)
					else:
						new_enemy.position = Vector2(pp.x+j,pp.y+400-i*100)
					new_enemy.walking_variant = self.walking_variant
					self.add_child(new_enemy)
					new_enemy.set_owner(self)
		if self.walking_variant == 1:
			self.walking_variant = 2
		else:
			self.walking_variant = 1
