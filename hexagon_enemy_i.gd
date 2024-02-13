extends RigidBody2D

var movement_speed = 200
var move_direction = null
const DEG2RAD = PI / 180.0
var rng = null
var direction_change_interval = 2
var direction_change_interval_timer = 2
var walking_variant = 1
var exp_worth = 1
var melee_dmg = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	self.name = "Enemy"
	self.rng = RandomNumberGenerator.new()

func _physics_process(delta):
	self.direction_change_interval_timer += delta
	if self.direction_change_interval_timer >= self.direction_change_interval:
		self.direction_change_interval_timer -= self.direction_change_interval
		self.change_direction()
	
func change_direction():
	# 1. calculate desired direction
	var angle = 80
	var velocity = self.global_position.direction_to(owner.get_node("Player").global_position)
	var cos = cos(angle * DEG2RAD)
	var sin = sin(angle * DEG2RAD)
	
	var v = null
	if walking_variant == 1:
		v = Vector2(cos*velocity.x - sin*velocity.y, sin*velocity.x + cos*velocity.y)
		self.movement_speed = 200
	elif walking_variant == 2:
		v = velocity
		self.movement_speed = 75
	elif walking_variant == 3:
		v = velocity
		self.movement_speed = 90
		self.direction_change_interval = 3.5
	elif walking_variant == 4:
		v = Vector2(cos*velocity.x + sin*velocity.y, - sin*velocity.x + cos*velocity.y)
		self.movement_speed = 200
	%Movement.movement_speed_changed()
	
	# 2. change it slightly, if other enemys/or objects are in the way (very close: within comfort zone), maybe in random direction then
	# 2.b or move random if previous direction is zero-vector
	
	if v.x == 0 and v.y == 0:
		v = Vector2(self.rng.randf_range(0,1), self.rng.randf_range(0,1)).normalized()
		self.direction_change_interval = self.rng.randf_range(0.1,0.3)
		self.direction_change_interval_timer = 0
	else:
		var nearest_collider = self.get_nearest_collider()
		if self.get_node("ComfortZone").get_overlapping_bodies().size() <= 30:
			nearest_collider = null
		if nearest_collider != null:
			#a) reverse direction
			v = nearest_collider.global_position.direction_to(self.global_position)
			# some noise
			v += Vector2(self.rng.randf_range(-0.1,0.1),self.rng.randf_range(-0.1,0.1))
			#v = Vector2(self.rng.randf_range(0,1),self.rng.randf_range(0,1))
			v.normalized()
			self.direction_change_interval = self.rng.randf_range(0.1,0.3)
			self.direction_change_interval_timer = 0
		else:
			self.direction_change_interval = 0
			self.direction_change_interval_timer = 0

	%Movement._set_direction(v)
	
func get_nearest_collider(comfort_range = self.get_node("ComfortZone")):
	var nearest_collider = null
	var closest_distance = 9999999
	for collider in comfort_range.get_overlapping_bodies():
		if collider != self:
			var distance = self.global_position.distance_to(collider.global_position)
			if distance < closest_distance:
				closest_distance = distance
				nearest_collider = collider
	return nearest_collider
	
	
func die():
	owner.get_node("Player").gain_exp(self.exp_worth)
