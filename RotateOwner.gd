extends Node

@export var traverse_circle = false
var traverse = 0.25
var pos = null
@export var direction = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	self.pos = get_parent().position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	get_parent().rotation -= 1 * delta * direction
	if self.traverse_circle:
		var r = 20
		get_parent().position = Vector2(pos.x + r*cos(2*PI*traverse),pos.y -r*sin(2*PI*traverse))
		self.traverse += delta * 0.3 * direction

		# x^2 = +- sqrt(r^2 - y^2)
		#	R * cos, R *sin
		# const DEG2RAD = PI / 180.0
		# cos(angle * D2R)
