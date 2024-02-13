extends CharacterBody2D

signal OnMovementSpeedChange()

var movement_speed = 200
var move_direction = null
var exp = 0
var skills_learned = 0
var skill_system = null
var hp = null

func _start():
	pass

func _physics_process(delta):
	skill_system = self.get_node("Weapon").get_node("SkillSystem")
	var move_direction = Vector2()
	move_direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	move_direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	move_direction = move_direction.normalized()
	if move_direction.x != 0 or move_direction.y != 0:
		self.move_direction = move_direction

	var hurtbox_dmg = 0
	for cb in self.get_node("HurtBox").get_overlapping_bodies():
		hurtbox_dmg += delta * cb.melee_dmg
	if hurtbox_dmg > 0:
		print("player gets hurtbox dmg:", hurtbox_dmg)
		if self.hp == null:
			self.get_node("Weapon").get_node("SkillSystem").skills_updated.connect(on_skills_update)
			self.hp = self.get_node("HealthPool")
		self.hp._get_damage(hurtbox_dmg)
		print(self.hp.health)
	
	%Movement._set_direction(move_direction)

func on_skills_update(skills):
	print("UPDATSLKJF")
	self.movement_speed = 200 + skills.running_speed * 20
	self.hp.max_health = 100 + skills.life_max * 10
	self.hp.health += 10
	self.hp.health_regen_per_sec = 1 + skills.life_reg * 0.1
	self.get_node("AttackRangeCircle").scale = Vector2(1,1) * (1 + skills.circle.attack_range * 0.2)
	self.get_node("AttackRangeLine").scale = Vector2(1,1) * (1 + skills.line.attack_range * 0.2)

func gain_exp(gain):
	self.exp += gain
	print(self.exp)
	var exp_required = 5 * (1 + self.skills_learned)
	if self.skill_system.offer_skill_upgrades_active == false:
		if self.exp >= exp_required:
			self.exp -= exp_required
			self.skill_system.offer_skill_upgrades()
			self.skills_learned += 1
