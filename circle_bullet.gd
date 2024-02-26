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
var circle_bullet = null
var aim_bot = false

# Called when the node enters the scene tree for the first time.
func _ready():
	self.name = "CircleBullet"
	self.circle_bullet = load("res://circle_bullet.tscn")
	self.body_entered.connect(_on_CircleBullet_body_entered)
	self.rng = RandomNumberGenerator.new()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if self.aim_bot:
		var circle_shape = CircleShape2D.new()
		circle_shape.radius = 200 #+ 20 * self.skill_state.line.attack_range
		var query_params = PhysicsShapeQueryParameters2D.new()
		query_params.shape = circle_shape
		query_params.transform = Transform2D(0, self.position)
		var space_state = get_world_2d().direct_space_state
		var result = space_state.intersect_shape(query_params)
		if result.size() > 0:
			var closest_target = null
			var closest_dist = 99999
			for res in result:
				var dist = self.global_position.distance_to(res["collider"].global_position)
				if (closest_target == null or dist < closest_dist) and "Player" not in res["collider"].name:
					closest_dist = dist
					closest_target = res["collider"]
				
			var target_pos = closest_target.global_position
			self.position += (target_pos - self.position).normalized() * delta * self.travel_speed
	else:
		if scaled_direction != null:
			self.position += scaled_direction * delta
	self.living_timer += delta
	if self.living_timer >= self.living_time * 0.6:
		self.queue_free()

func request_destruction():
	if self.rng.randf_range(0,1) <= self.bounce:
		var direction = Vector2(self.rng.randf_range(-1,1), self.rng.randf_range(-1,1)).normalized()
		self.scaled_direction = direction * self.travel_speed
	if true:
		for i in range(self.split):
			var new_bullet = self.circle_bullet.instantiate()
			var direction = Vector2(self.rng.randf_range(-1,1), self.rng.randf_range(-1,1)).normalized()
			#self.scaled_direction = direction * self.travel_speed
			new_bullet.damage = self.damage / 1.5
			new_bullet.living_time = self.living_time / 1.5
			new_bullet.crit = self.crit
			new_bullet.crit_factor = self.crit_factor
			new_bullet.bounce = self.bounce
			new_bullet.destructable = self.destructable
			new_bullet.split = self.split - 1 if self.split >= 1 else 0
			new_bullet.shoot(direction)
			new_bullet.transform = self.global_transform
			#print(new_bullet.transform)
			new_bullet.scale = Vector2(0.5, 0.5)
			get_tree().get_root().get_node("Map_1").add_child(new_bullet)
			
		if self.destructable:
			self.queue_free() 

func shoot(direction):
	self.scaled_direction = direction * self.travel_speed

func _on_CircleBullet_body_entered(body):
	#if "Enemy" in body.name:
	self.deal_damage(body)
	self.request_destruction()
	
	
func deal_damage(body):
	if self.rng.randf_range(0,1) <= self.crit:
		body.get_node("HealthPool")._get_damage(self.damage * self.crit_factor)
	else:
		body.get_node("HealthPool")._get_damage(self.damage)

func scale_size(factor):
	get_node("CircleShape").length = 20 * factor
	get_node("CircleShape")._draw()
	get_node("CollisionShape2D").shape.radius = 20 * factor
