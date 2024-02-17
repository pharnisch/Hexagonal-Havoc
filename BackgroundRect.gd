extends ColorRect


var hue = 0.7
var hue_going_up = true
var min_intensity = 0.1
var max_intensity = 0.3
var intensity = 0.1
var intensity_going_up = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


	# nice color: f1e5ff

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if hue_going_up:
		self.hue += delta * 0.05
		if self.hue >= 1:
			self.hue_going_up = false
	else:
		self.hue -= delta * 0.05
		if self.hue <= 0:
			self.hue_going_up = true
		
	if intensity_going_up:
		self.intensity += delta * 0.05
		if self.intensity >= max_intensity:
			self.intensity_going_up = false
	else:
		self.intensity -= delta * 0.05
		if self.intensity <= min_intensity:
			self.intensity_going_up = true
	
	
	get_parent().get_parent().rainbow_color = Color.from_hsv(self.hue, self.intensity, 1., 1.)
	if get_parent().get_parent().colors_inverted:
		self.color = Color.from_hsv(self.hue, self.intensity, 1., 1.)
	else:
		self.color = Color.from_hsv(self.hue, self.intensity+0.2, 1., 1.)
#	#if get_parent().get_parent().colors_inverted:
#		self.color = Color.BLACK
#	else:
#		self.color = Color.from_hsv(self.hue, self.intensity, 1., 1.)
