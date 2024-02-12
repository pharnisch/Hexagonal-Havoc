extends Node2D

@export var max_health := 100
@export var health_regen_per_sec := 1
var min_health = 0
var health = null
var text_label = null

# Called when the node enters the scene tree for the first time.
func _ready():
	self.health = self.max_health
	self.text_label = load("res://text_label.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.health += self.health_regen_per_sec * delta
	if self.health > self.max_health:
		self.health = self.max_health
		
func _get_damage(dmg):
	#print("get dmg: ", dmg)
	self.health -= dmg
	self._display_damage(dmg)
	if self.health < self.min_health:
		self.health = self.min_health
	self._update_health_display()
	
	if self.health <= 0:
		owner.queue_free() # destroy parent
		#self.player.add_score(5)
		
func _update_health_display():
	pass
	#print(self.health)
	# show life bar or change color/texture/shape of entity
	
func _display_damage(dmg):
	var text_label = self.text_label.instantiate()
	text_label.position = owner.position
	text_label.set_value(dmg)
	owner.owner.add_child(text_label)
	
	
