extends ColorRect


var hue = 0.7

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


	# nice color: f1e5ff

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.hue -= delta * 0.05
	if self.hue > 1.:
		self.hue = 0
	self.color = Color.from_hsv(self.hue, 0.2, 1., 1.)
