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
var movement_speed_factor = 1

var player = null
var circle_bullet = null
var square_bullet = null
var triangle_bullet = null
var line_bullet = null
var reload_time_line = 5
var reload_timer_line = 0
var reload_time_circle = 3
var reload_timer_circle = 0
var reload_time_square = 8
var reload_timer_square = 0
var reload_time_triangle = 999999999
var reload_timer_triangle = 999999999
var weapon = null

# Called when the node enters the scene tree for the first time.
func _ready():
	self.name = "Enemy"
	self.rng = RandomNumberGenerator.new()
	self.player = get_parent().get_node("Player")
	self.circle_bullet = load("res://circle_bullet.tscn")
	self.square_bullet = load("res://square_bullet.tscn")
	self.line_bullet = load("res://line_bullet.tscn")
	self.triangle_bullet = load("res://triangle_bullet.tscn")

func _physics_process(delta):
	if weapon != null:
		weapon.call(delta)
	#self.circle_logic(delta)
	#self.line_logic(delta)
	#self.square_logic(delta)
	#self.triangle_logic(delta)

	
	
	#print("decr")
	get_parent().decrease_agony(delta)
	
	self.direction_change_interval_timer += delta
	if self.direction_change_interval_timer >= self.direction_change_interval:
		self.direction_change_interval_timer -= self.direction_change_interval
		self.change_direction()
		
		
	#if !get_parent().colors_inverted:
	#	self.get_node("HexagonShape").color = Color.BLACK
	#	self.get_node("HexagonShape").queue_redraw()
	#else:
	#	self.get_node("HexagonShape").color = Color.GRAY #(self.get_parent().rainbow_color+Color.BLACK)/2
	#	self.get_node("HexagonShape").queue_redraw()
	
func change_direction():
	# 1. calculate desired direction
	var angle = 80
	var velocity = self.global_position.direction_to(owner.get_node("Player").global_position)
	var cos = cos(angle * DEG2RAD)
	var sin = sin(angle * DEG2RAD)
	
	var v = null
	if walking_variant == 1:
		v = Vector2(cos*velocity.x - sin*velocity.y, sin*velocity.x + cos*velocity.y)
		self.movement_speed = 200 * movement_speed_factor
	elif walking_variant == 2:
		v = velocity
		self.movement_speed = 65 * movement_speed_factor
	elif walking_variant == 3:
		v = velocity
		self.movement_speed = 75 * movement_speed_factor
		self.direction_change_interval = 7
	elif walking_variant == 4:
		v = Vector2(cos*velocity.x + sin*velocity.y, - sin*velocity.x + cos*velocity.y)
		self.movement_speed = 200 * movement_speed_factor
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

func line_logic(delta):	
	self.reload_timer_line += delta
	if self.reload_timer_line >= self.reload_time_line:
		self.reload_timer_line -= self.reload_time_line

		var new_bullet = line_bullet.instantiate()

		new_bullet.get_node("LineShape").width = 10
			
		# overshooting scale
		var v = (self.player.global_position - self.global_position).normalized()
		
		new_bullet.set_points(self.global_position, self.global_position + v * 200)
		new_bullet.damage = 5
		new_bullet.living_time = 1
		
		new_bullet.collision_layer = 8
		new_bullet.collision_mask = 17
		new_bullet.get_node("LineShape").color = Color.BLACK		
		
		await self.loading_anim(3, 35)
		owner.add_child(new_bullet)

func circle_logic(delta):
	self.reload_timer_circle += delta
	if self.reload_timer_circle >= self.reload_time_circle:
		self.reload_timer_circle -= self.reload_time_circle
		
		var new_bullet = self.circle_bullet.instantiate()
		new_bullet.damage = 5
		
		
		
		
		get_parent().add_child(new_bullet)
		new_bullet.transform = self.global_transform
		#new_bullet.apply_central_impulse(direction * 500) 
		var direction = (self.player.global_position - self.global_position).normalized()
		
		#new_bullet.set_collision_layer_bit(1, false) 
		#new_bullet.set_collision_layer_bit(3, true) 
		#new_bullet.set_collision_mask_bit(2, false)
		#new_bullet.set_collision_mask_bit(0, true)
		new_bullet.collision_layer = 8
		new_bullet.collision_mask = 17
		new_bullet.travel_speed = 200
		new_bullet.get_node("CircleShape").color = Color.BLACK
		await self.loading_anim(1.5, 10)
		if new_bullet != null:
			new_bullet.living_time = 50
			new_bullet.shoot(direction)

func triangle_logic(delta):
	self.reload_timer_triangle += delta
	if self.reload_timer_triangle >= self.reload_time_triangle:
		self.reload_timer_triangle -= self.reload_time_triangle
		
		var new_bullet = triangle_bullet.instantiate()		
		new_bullet.collision_layer = 8
		new_bullet.collision_mask = 17
		new_bullet.get_node("TriangleShape").color = Color.BLACK
		new_bullet.damage = 5
		new_bullet.living_time = 999999999
		new_bullet.get_node("TriangleShape").growing_speed = 0
		#new_bullet.get_node("TriangleShape").rotation_speed = 0
		new_bullet.scale_up(0.1)
		new_bullet.traverse_circle = true
		new_bullet.traverse_radius = 100
		new_bullet.traverse_speed = 0.3
	
		self.add_child(new_bullet)
		
func square_logic(delta):
	self.reload_timer_square += delta
	if self.reload_timer_square >= self.reload_time_square:
		self.reload_timer_square -= self.reload_time_square
		
		var new_bullet = square_bullet.instantiate()		
		new_bullet.collision_layer = 8
		new_bullet.collision_mask = 17
		new_bullet.get_node("SquareShape").color = Color.BLACK
		new_bullet.damage = 10
		new_bullet.living_time = 3
		new_bullet.get_node("SquareShape").growing_speed = 0.01
		new_bullet.collapsing = 1
		#new_bullet.stun_chance = 0.1 + self.skill_state.square.stun_chance * 0.1
		#new_bullet.stun_time = 0.50 + self.skill_state.square.stun_time * 0.25
		
		#new_bullet.apply_central_impulse(direction * 500) 
		self.get_node("HexagonShape").rotation_speed = 5
		await loading_anim(4, 20)
		self.get_node("HexagonShape").rotation_speed = 1
		
		get_parent().add_child(new_bullet)
		new_bullet.transform = self.global_transform
		new_bullet.shoot(Vector2(0,0))
		
func loading_anim(secs, w):
	var tmp_spd = movement_speed_factor
	movement_speed_factor = 0
	var tmp_wid = self.get_node("HexagonShape").width
	self.get_node("HexagonShape").width = w
	self.get_node("HexagonShape").queue_redraw()

	await get_tree().create_timer(secs, false).timeout
	
	movement_speed_factor = tmp_spd
	self.get_node("HexagonShape").width = tmp_wid
	self.get_node("HexagonShape").queue_redraw()
	self.get_node("HexagonShape")._draw()
