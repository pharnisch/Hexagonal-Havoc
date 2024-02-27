extends Area2D

@export var damage := 7
@export var destructable := false
@export var living_time := 4.5
@export var travel_speed := 0
@export var aim_required = false
var living_timer = 0
var scaled_direction = null
var crit = 0
var crit_factor = 1.5
var rng = null
var traverse_circle = false
var traverse = 0.25
var traverse_radius = 100
var traverse_speed = 0.3

# Called when the node enters the scene tree for the first time.
func _ready():
	self.name = "TriangleBullet"
	self.body_entered.connect(_on_TriangleBullet_body_entered)
	self.rng = RandomNumberGenerator.new()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if scaled_direction != null:
		self.position += scaled_direction * delta
	if traverse_circle:
		var r = self.traverse_radius
		self.position = Vector2(0 + r*cos(2*PI*self.traverse),0 -r*sin(2*PI*self.traverse))
		self.traverse += delta * self.traverse_speed
	self.living_timer += delta
	if self.living_timer >= self.living_time:
		self.queue_free()

func request_destruction():
	if self.destructable:
		self.queue_free() 

func shoot(direction):
	self.scaled_direction = direction * self.travel_speed

func _on_TriangleBullet_body_entered(body):
	#if "Enemy" in body.name:
	self.deal_damage(body)
	self.request_destruction()
	
func deal_damage(body):
	if self.rng.randf_range(0,1) <= self.crit:
		body.get_node("HealthPool")._get_damage(self.damage * self.crit_factor)
	else:
		body.get_node("HealthPool")._get_damage(self.damage)

func scale_up(factor):
	get_node("TriangleShape").scale_factor = factor
