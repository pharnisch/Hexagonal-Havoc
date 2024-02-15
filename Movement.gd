extends Node2D

@export var entity : PhysicsBody2D
var speed = null
var direction = null
var stun_time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	self.speed = self.entity.movement_speed
	#self.entity.OnMovementSpeedChange.connect(_change_speed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if stun_time > 0:
		stun_time -= delta
		return
	if self.direction != null:
		self.entity.move_and_collide(self.direction * self.speed * delta)
		#self.entity.position += self.direction * self.speed * delta

func _set_direction(direction : Vector2):
	self.direction = direction

func _set_target(target : Vector2):
	self._set_direction((target - self.entity.global_position).normalized())
	
func movement_speed_changed():
	self.speed = self.entity.movement_speed
	
func stun(stun_time):
	self.stun_time += stun_time

