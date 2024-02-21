extends Node2D

var circle_bullet = null
var square_bullet = null
var line_bullet = null
var triangle_bullet = null
var line_sun_beam = 0
var line_overshoot = 0
var reload_time_line = 999999999
var reload_timer_line = 0
var reload_time_circle = 1
var reload_timer_circle = 0
var reload_time_square = 999999999
var reload_timer_square = 0
var reload_time_square_echo = 999999999
var reload_timer_square_echo = 0
var reload_time_triangle_surrounding = 999999999
var reload_timer_triangle_surrounding = 0
var reload_time_triangle = 999999999
var reload_timer_triangle = 0
const DEG2RAD = PI / 180.0
var rng = null
var skill_state = null

# Called when the node enters the scene tree for the first time.
func _ready():
	self.circle_bullet = load("res://circle_bullet.tscn")
	self.square_bullet = load("res://square_bullet.tscn")
	self.line_bullet = load("res://line_bullet.tscn")
	self.triangle_bullet = load("res://triangle_bullet.tscn")
	self.rng = RandomNumberGenerator.new()
	self.get_node("SkillSystem").skills_updated.connect(on_skills_update)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	self.reload_timer_line += delta
	if self.reload_timer_line >= self.reload_time_line:
		self.reload_timer_line -= self.reload_time_line
		if self.skill_state != null and self.skill_state.line.learned:
			self.beam(self.line_bullet)

	self.reload_timer_circle += delta
	if self.reload_timer_circle >= self.reload_time_circle:
		self.reload_timer_circle -= self.reload_time_circle
		if self.skill_state != null and self.skill_state.circle.learned:
			self._shoot(self.circle_bullet)

	self.reload_timer_square += delta
	if self.reload_timer_square >= self.reload_time_square:
		self.reload_timer_square -= self.reload_time_square
		if self.skill_state != null and self.skill_state.square.learned:
			self._shoot(self.square_bullet, Vector2(0,0))	

	self.reload_timer_square_echo += delta
	if self.reload_timer_square_echo >= self.reload_time_square_echo:
		self.reload_timer_square_echo -= self.reload_time_square_echo
		if self.skill_state != null and self.skill_state.square.learned:
			self._shoot(self.square_bullet, Vector2(0,0), owner.owner, true)	

	self.reload_timer_triangle += delta
	if self.reload_timer_triangle >= self.reload_time_triangle:
		self.reload_timer_triangle -= self.reload_time_triangle
		if self.skill_state != null and self.skill_state.triangle.learned:
			self.equip_triangle_shield(self.triangle_bullet)

	self.reload_timer_triangle_surrounding += delta
	if self.reload_timer_triangle_surrounding >= self.reload_time_triangle_surrounding:
		self.reload_timer_triangle_surrounding -= self.reload_time_triangle_surrounding
		if self.skill_state != null and self.skill_state.triangle.learned:
			self.equip_triangle_surrounding(self.triangle_bullet)
			
		
func equip_triangle_shield(bullet_template):
	var new_bullet = bullet_template.instantiate()
	new_bullet.damage = 10 * 9 * (1 + self.skill_state.triangle.damage / 10. + self.skill_state.damage / 30.)
	new_bullet.living_time = 4.5 * (1 + self.skill_state.triangle.living_time / 4. + self.skill_state.living_time / 8.)
	new_bullet.crit = 0.05 + 1. * (self.skill_state.triangle.crit / 8. + self.skill_state.crit / 20.)
	new_bullet.crit_factor = 1.5 * (1 + self.skill_state.triangle.crit_factor / 5. + self.skill_state.crit_factor / 10.)
	
	new_bullet.get_node("TriangleShape").growing_speed = 0.05 * (1 + self.skill_state.triangle.growing_speed / 3.)
	new_bullet.get_node("TriangleShape").rotation_speed = 3 * (1 + self.skill_state.triangle.rotation_speed / 3.)
	#new_bullet.get_node("TriangleShape").growing_min_scale = 1.5 * (1 + self.skill_state.triangle.growing_min_scale / 10.)
	new_bullet.get_node("TriangleShape").growing_max_scale = 2.5 * (1 + self.skill_state.triangle.growing_max_scale / 3.)
	
	owner.add_child(new_bullet)
	
func equip_triangle_surrounding(bullet_template):
	var new_bullet = bullet_template.instantiate()
	new_bullet.damage = 10 * 1. * (1 + self.skill_state.triangle.damage / 10. + self.skill_state.damage / 30.)
	new_bullet.living_time = 15 * (1 + self.skill_state.triangle.living_time / 4. + self.skill_state.living_time / 8.)
	new_bullet.crit = 0.05 + 1. * (self.skill_state.triangle.crit / 8. + self.skill_state.crit / 20.)
	new_bullet.crit_factor = 3. * (1 + self.skill_state.triangle.crit_factor / 5. + self.skill_state.crit_factor / 10.)
	
	new_bullet.scale_up(0.3)
	new_bullet.get_node("TriangleShape").growing_speed = 0.05 * (1 + self.skill_state.triangle.growing_speed / 3.)
	new_bullet.get_node("TriangleShape").rotation_speed = 3 * (1 + self.skill_state.triangle.rotation_speed / 3.)
	#new_bullet.get_node("TriangleShape").growing_min_scale = 1.5 * (1 + self.skill_state.triangle.growing_min_scale / 10.)
	new_bullet.get_node("TriangleShape").growing_max_scale = 2.5 * (1 + self.skill_state.triangle.growing_max_scale / 3.)
	
	new_bullet.traverse_circle = true
	new_bullet.traverse_radius = 400
	
	owner.add_child(new_bullet)

func beam(bullet_template):
	var nearest_enemy = self.get_nearest_enemy(owner.get_node("AttackRangeLine"))
	if nearest_enemy == null:
		self.reload_timer_line = self.reload_time_line
		return
	var sun_proc = self.rng.randf_range(0,1) <= self.line_sun_beam
	if sun_proc:
		self.beam_sun(bullet_template, nearest_enemy.global_position)
	else:
		self._beam(bullet_template, nearest_enemy.global_position)

func _beam(bullet_template, target_position, main_beam = true):
	var new_bullet = bullet_template.instantiate()
	
	# overshooting scale
	var v = target_position - owner.global_position
	target_position = owner.global_position + v * (1 + self.line_overshoot / 4.)
	
	new_bullet.set_points(owner.global_position, target_position)
	new_bullet.damage = 10 * 8 * (1 + self.skill_state.line.damage / 10. + self.skill_state.damage / 30.)
	new_bullet.living_time = 0.5 * (1 + self.skill_state.line.living_time / 4. + self.skill_state.living_time / 8.)
	new_bullet.crit = 0.05 + 1. * (self.skill_state.line.crit / 8. + self.skill_state.crit / 20.)
	new_bullet.crit_factor = 2.0 * (1 + self.skill_state.line.crit_factor / 5. + self.skill_state.crit_factor / 10.)
	#new_bullet.destructable = !self.skill_state.line.indestructable
	new_bullet.destructable = !(self.rng.randf_range(0,1) <= self.skill_state.line.indestructable * 0.15)
	owner.owner.add_child(new_bullet)
	
func beam_sun(bullet_template, main_target_position):
	self._beam(bullet_template, main_target_position)
	var velocity = main_target_position - owner.global_position
	var total_beams = 12
	var min_factor = 1.
	var max_factor = 2.
	for i in range(total_beams-1):
		var angle = 30*(i+1)
		var c = cos(angle * DEG2RAD)
		var s = sin(angle * DEG2RAD)	
		var v = Vector2(velocity.x*c-velocity.y*s, velocity.x*s + velocity.y*c) * self.rng.randf_range(min_factor, max_factor)
		self._beam(bullet_template, owner.global_position + v, false)

func _shoot(bullet_template, shoot_direction = null, parent = owner.owner, square_echo = false):
	var new_bullet = bullet_template.instantiate()
	
	if shoot_direction == null: # circle
		new_bullet.damage = 10 * 12 * (1. + self.skill_state.circle.damage / 10. + self.skill_state.damage / 30.)
		var living_time_multiplier = (1. + self.skill_state.circle.living_time / 4. + self.skill_state.living_time / 8.)
		var product = living_time_multiplier * 1
		new_bullet.living_time = product
		new_bullet.crit = 0.05 + 1. * (self.skill_state.circle.crit / 8. + self.skill_state.crit / 20.)
		# bullet has higher crit factor from start!
		new_bullet.crit_factor = 2 * (1 + self.skill_state.circle.crit_factor / 5. + self.skill_state.crit_factor / 10.)
		new_bullet.bounce = self.skill_state.circle.bounce * 0.20
	
		#new_bullet.destructable = !self.skill_state.circle.indestructable
		new_bullet.destructable = !(self.rng.randf_range(0,1) <= self.skill_state.circle.indestructable * 0.15)
		new_bullet.split = self.skill_state.circle.split
	else: # square
		new_bullet.damage = 10 * 20 * (1 + self.skill_state.square.damage / 10. + self.skill_state.damage / 30.)
		new_bullet.living_time = 2 * (1 + self.skill_state.square.living_time / 4. + self.skill_state.living_time / 8.)
		new_bullet.crit = 0.05 + 1. * (self.skill_state.square.crit / 8. + self.skill_state.crit / 20.)
		new_bullet.crit_factor = 1.2 * (1 + self.skill_state.square.crit_factor / 5. + self.skill_state.crit_factor / 10.)
		
		#new_bullet.get_node("SquareShape").growing_speed = 0.05 * (1 + self.skill_state.square.growing_speed / 10.)
		#new_bullet.get_node("SquareShape").rotation_speed = 1 * (1 + self.skill_state.square.rotation_speed / 10.)
		new_bullet.collapsing = self.rng.randf_range(0,1) <= (self.skill_state.square.collapsing * 0.1)
		new_bullet.stun_chance = 0.1 + self.skill_state.square.stun_chance * 0.1
		new_bullet.stun_time = 0.50 + self.skill_state.square.stun_time * 0.25
		
		if square_echo:
			new_bullet.damage = new_bullet.damage / 4.
			new_bullet.get_node("SquareShape").width = 1
			new_bullet.get_node("SquareShape")._draw()
			new_bullet.stun_time /= 3.
		
	var direction = Vector2(0,1)
	if new_bullet.aim_required:
		var nearest_enemy = self.get_nearest_enemy(owner.get_node("AttackRangeCircle"))
		if nearest_enemy == null:
			if shoot_direction == null: # circle
				self.reload_timer_circle -= self.reload_time_circle
			new_bullet.queue_free()
			return
		direction = self.global_position.direction_to(nearest_enemy.global_position)
	else:
		if owner.move_direction != null:
			direction = owner.move_direction
		if shoot_direction != null:
			direction = shoot_direction
	
	parent.add_child(new_bullet)
	new_bullet.transform = owner.global_transform
	#new_bullet.apply_central_impulse(direction * 500) 
	new_bullet.shoot(direction)

func get_nearest_enemy(attack_range = owner.get_node("AttackRange")):
	var closest_enemy = null
	var closest_distance = 9999999
	#print("in weap", attack_range.get_overlapping_bodies())
	for enemy in attack_range.get_overlapping_bodies():
		var distance = self.global_position.distance_to(enemy.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_enemy = enemy
	return closest_enemy
		
func on_skills_update(new_skill_state):
	#print(new_skill_state)
	self.skill_state = new_skill_state

	self.reload_time_circle = 0.9 / (1 + self.skill_state.circle.casting_speed / 10. + self.skill_state.casting_speed / 30.)
	
	if self.skill_state.line.learned:
		if self.reload_time_line > 999999:
			self.reload_time_line = 0.6 / (1 + self.skill_state.line.casting_speed / 10. + self.skill_state.casting_speed / 30.)
			self.reload_timer_line = self.reload_time_line
		self.reload_time_line = 0.6 / (1 + self.skill_state.line.casting_speed / 10. + self.skill_state.casting_speed / 30.)
	
	if self.skill_state.square.learned:
		if self.reload_time_square > 999999:
			self.reload_time_square = 13 / (1 + self.skill_state.square.casting_speed / 10. + self.skill_state.casting_speed / 30.)
			self.reload_timer_square = self.reload_time_square
		self.reload_time_square = 13 / (1 + self.skill_state.square.casting_speed / 10. + self.skill_state.casting_speed / 30.)
		
	if self.skill_state.triangle.learned:
		if self.reload_time_triangle > 999999:
			self.reload_time_triangle = 7 / (1 + self.skill_state.triangle.casting_speed / 10. + self.skill_state.casting_speed / 30.)
			self.reload_timer_triangle = self.reload_time_triangle
		self.reload_time_triangle = 7 / (1 + self.skill_state.triangle.casting_speed / 10. + self.skill_state.casting_speed / 30.)
	

	self.line_sun_beam = self.skill_state.line.sun_beam / 40.
	self.line_overshoot = self.skill_state.line.overshoot


	if self.skill_state.square.echo == 1 and reload_time_square_echo > 999999:
		self.reload_time_square_echo = self.reload_time_square / self.skill_state.square.echo - 0.5 if self.skill_state.square.echo > 0 else 999999999
		self.reload_timer_square_echo = self.reload_time_square_echo
	elif self.skill_state.square.echo >= 1:
		self.reload_time_square_echo = self.reload_time_square / self.skill_state.square.echo - 0.5 if self.skill_state.square.echo > 0 else 999999999
	

	if self.skill_state.triangle.surrounding == 1 and reload_time_triangle_surrounding > 999999:
		self.reload_time_triangle_surrounding = self.reload_time_triangle / self.skill_state.triangle.surrounding if self.skill_state.triangle.surrounding > 0 else 999999999
		self.reload_timer_triangle_surrounding = self.reload_time_triangle_surrounding
	elif self.skill_state.triangle.surrounding >= 1:
		self.reload_time_triangle_surrounding = self.reload_time_triangle / self.skill_state.triangle.surrounding if self.skill_state.triangle.surrounding > 0 else 999999999

	

