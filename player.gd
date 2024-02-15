extends CharacterBody2D

signal OnMovementSpeedChange()
signal on_exp_change(lvl, exp, exp_for_next_skill, total_exp)

var movement_speed = 200
var move_direction = null
var exp = 0
var total_exp = 0
var skills_learned = 0
var skill_system = null
var hp = null
var exp_bonus = 0

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
		#print("player gets hurtbox dmg:", hurtbox_dmg)
		if self.hp == null:
			self.get_node("Weapon").get_node("SkillSystem").skills_updated.connect(on_skills_update)
			self.hp = self.get_node("HealthPool")
		self.hp._get_damage(hurtbox_dmg, ":(")
		#print(self.hp.health)
	
	%Movement._set_direction(move_direction)
	
func die():
	get_tree().paused = true
	#get_node("/root/Map_1/UI/RestartButton").visible = true

func on_skills_update(skills):
	var new_max_health = 100 + skills.life_max * 50
	print(new_max_health, self.hp.max_health)
	if new_max_health > self.hp.max_health:
		self.hp.max_health = new_max_health
		self.hp.health += 50
	self.movement_speed = 200 + skills.running_speed * 40
	self.get_node("Movement").movement_speed_changed()
	self.hp.health_regen_per_sec = 1 + skills.life_reg * 0.5
	self.get_node("AttackRangeCircle").scale = Vector2(1,1) * (1 + skills.circle.attack_range * 0.2 + skills.attack_range * 0.1)
	self.get_node("AttackRangeLine").scale = Vector2(1,1) * (1 + skills.line.attack_range * 0.2 + skills.attack_range * 0.1)
	self.exp_bonus = skills.exp_bonus * 0.1

func gain_exp(gain):
	gain *= (1. + self.exp_bonus)
	self.exp += gain
	self.total_exp += gain

	var exp_required = 2 + round(self.skills_learned * 1) + round(self.skills_learned *  self.skills_learned * 0.02) 
	on_exp_change.emit(self.skills_learned, self.exp, exp_required, self.total_exp)
	if self.skill_system.offer_skill_upgrades_active == false:
		if self.exp >= exp_required:
			self.exp -= exp_required
			self.skill_system.offer_skill_upgrades()
			self.skills_learned += 1
			exp_required = 2 + round(self.skills_learned * 1) + round(self.skills_learned *  self.skills_learned * 0.02) 
			on_exp_change.emit(self.skills_learned, self.exp, exp_required, self.total_exp)
