extends CharacterBody2D

signal OnMovementSpeedChange()

var movement_speed = 200
var move_direction = null

func _physics_process(delta):
	var move_direction = Vector2()
	move_direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	move_direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	move_direction = move_direction.normalized()
	if move_direction.x != 0 or move_direction.y != 0:
		self.move_direction = move_direction

	#self.move_and_collide(move_direction * delta * self.movement_speed)
	
	%Movement._set_direction(move_direction)
