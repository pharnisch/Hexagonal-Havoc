extends CollisionShape2D

var time = 1
var timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	self.timer += delta
	if self.timer >= self.time:
		self.timer -= self.time
		#print(self.global_position)
		#print("in coll:",owner.get_overlapping_bodies())
