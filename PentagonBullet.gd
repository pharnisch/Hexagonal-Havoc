extends Area2D

@export var damage := 10
@export var destructable := true
@export var living_time := 5
@export var travel_speed := 500
@export var aim_required = true
var living_timer = 0
var scaled_direction = null
var crit = 0
var crit_factor = 1.5
var rng = null
var bounce = 0
var split = 0
var bullet = null

# Called when the node enters the scene tree for the first time.
func _ready():
	self.name = "PentagonBullet"
	self.bullet = load("res://pentagon_bullet.tscn")
	self.body_entered.connect(_on_body_entered)
	self.rng = RandomNumberGenerator.new()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if scaled_direction != null:
		self.position += scaled_direction * delta
	self.living_timer += delta
	if self.living_timer >= self.living_time:
		self.queue_free()

func request_destruction():			
	if self.destructable:
		self.queue_free() 

func shoot(direction):
	self.scaled_direction = direction * self.travel_speed

func _on_body_entered(body):
	if "Enemy" in body.name:
		self.deal_damage(body)
		self.request_destruction()
	
func deal_damage(body):
	if self.rng.randf_range(0,1) <= self.crit:
		body.get_node("HealthPool")._get_damage(self.damage * self.crit_factor)
	else:
		body.get_node("HealthPool")._get_damage(self.damage)
