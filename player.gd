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
var touch_direction = Vector2()

var start_sound = null
var rank_up_sound = null
var sound_player = null
var die_sound = null

var endUI = load("res://end_ui.tscn")

var latest_touch_index: int = -1
var is_pressed: bool = false


func _start():
	self.name = "Player"
	


func _physics_process(delta):
	if sound_player == null:
		sound_player = get_parent().get_node("SoundPlayer")
		start_sound = preload("res://hexagon_assets/begin.wav")
		rank_up_sound = preload("res://hexagon_assets/rankup.wav")
		die_sound = preload("res://hexagon_assets/gameover.wav")
		sound_player.stream = start_sound
		sound_player.play()
	
	if self.hp == null:
		skill_system = self.get_node("Weapon").get_node("SkillSystem")
		skill_system.skills_updated.connect(on_skills_update)
		self.hp = self.get_node("HealthPool")
		
	
	var move_direction = Vector2()
	move_direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	move_direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if self.touch_direction != Vector2():
		move_direction = self.touch_direction
	
	var os_name = OS.get_name()



	
	move_direction = move_direction.normalized()
	var camera_rotated = self.get_node("Camera2D").rotation
	move_direction = move_direction.rotated(camera_rotated)
	#print(move_direction)
	if move_direction.x != 0 or move_direction.y != 0:
		self.move_direction = move_direction

	var hurtbox_dmg = 0
	for cb in self.get_node("HurtBox").get_overlapping_bodies():
		hurtbox_dmg += delta * cb.melee_dmg
	if hurtbox_dmg > 0:
		#print("player gets hurtbox dmg:", hurtbox_dmg)

		self.hp._get_damage(hurtbox_dmg, ":(")
		#print(self.hp.health)
	
	%Movement._set_direction(move_direction)
	
	
# Mobile Steuerung (Touch-Eingabe)

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:  # When the mouse button is pressed
			is_pressed = true
			
			# Calculate the direction relative to the screen center when clicked
			var screen_center = get_viewport().get_visible_rect().size / 2
			move_direction = (event.position - screen_center).normalized()
			self.touch_direction = move_direction  # You can use this for movement
			
			print("Mouse pressed at position: ", event.position)
		
		elif not event.pressed and is_pressed:  # When the mouse button is released
			self.touch_direction = Vector2()
			is_pressed = false
			print("Mouse released")
	
	# Handle mouse movement while pressed
	if is_pressed and (event is InputEventMouseMotion):
		# Update the move direction as the mouse slides
		var screen_center = get_viewport().get_visible_rect().size / 2
		move_direction = (event.position - screen_center).normalized()
		self.touch_direction = move_direction  # You can use this for movement
		
		print("Mouse moved, new direction: ", move_direction)
	
	
	# Mobile Steuerung (Touch-Eingabe)
	if event is InputEventScreenTouch:
		if event.pressed:  # When a touch begins
			# Update the latest touch index
			latest_touch_index = event.index
			is_pressed = true

			# Calculate the direction relative to the screen center
			var screen_center = get_viewport().get_visible_rect().size / 2
			move_direction = (event.position - screen_center).normalized()
			touch_direction = move_direction  # Use this for movement

			print("Touch pressed at position: ", event.position, ", index: ", event.index)

		elif not event.pressed and event.index == latest_touch_index:  # When the latest touch ends
			touch_direction = Vector2()
			is_pressed = false
			print("Touch released, index: ", event.index)
			latest_touch_index = -1  # Reset the latest touch index

	elif event is InputEventScreenDrag and event.index == latest_touch_index:
		# Update the move direction for the latest touch while dragging
		var screen_center = get_viewport().get_visible_rect().size / 2
		move_direction = (event.position - screen_center).normalized()
		touch_direction = move_direction

		print("Touch moved, new direction: ", move_direction, ", index: ", event.index)
			
func die():
	sound_player.stream = die_sound
	sound_player.play()
	get_tree().get_root().get_child(0).get_node("UI").get_script().save_highscore()
	get_tree().paused = true
	var eUI = self.endUI.instantiate()
	get_parent().get_node("UI").add_child(eUI)

func on_skills_update(skills):
	print("CHAR:UPDATE")
	var new_max_health = 100 + skills.life_max * 50
	#print(new_max_health, self.hp.max_health)
	if new_max_health > self.hp.max_health:
		self.hp.max_health = new_max_health
		self.hp.health += 50
	self.movement_speed = 200 + skills.running_speed * 40
	self.get_node("Movement").movement_speed_changed()
	self.hp.health_regen_per_sec = 0.5 + skills.life_reg * 0.25
	self.get_node("AttackRangeCircle").scale = Vector2(1,1) * (1 + skills.circle.attack_range * 0.2 + skills.attack_range * 0.1)
	self.get_node("AttackRangeLine").scale = Vector2(1,1) * (1 + skills.line.attack_range * 0.2 + skills.attack_range * 0.1)
	print(self.get_node("AttackRangeLine").scale)
	self.exp_bonus = skills.exp_bonus * 0.05

func gain_exp(gain):
	gain *= (1. + self.exp_bonus)
	self.exp += gain
	self.total_exp += gain

	var exp_required = 2 + round(self.skills_learned * 1) + round(self.skills_learned *  self.skills_learned * 0.02) 
	#var exp_required = 
	on_exp_change.emit(self.skills_learned, self.exp, exp_required, self.total_exp)
	if self.skill_system.offer_skill_upgrades_active == false:
		if self.exp >= exp_required:
			sound_player.stream = rank_up_sound
			sound_player.play()
			self.exp -= exp_required
			self.skill_system.offer_skill_upgrades()
			self.skills_learned += 1
			exp_required = 2 + round(self.skills_learned * 1) + round(self.skills_learned *  self.skills_learned * 0.02) 
			on_exp_change.emit(self.skills_learned, self.exp, exp_required, self.total_exp)
