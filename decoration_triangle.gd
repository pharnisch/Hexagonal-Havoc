extends Control

@export var color := Color.WHITE
@export var width := 20
@export var length = 50
@export var rotation_speed = 10
@export var growing_speed := 0.05
var shrinking = false
@export var growing_min_scale := 1.5
@export var growing_max_scale := 2.5


func _ready():
	self.rotation = 0
	owner.scale *= self.growing_min_scale

func _physics_process(delta):
	owner.rotation -= rotation_speed * delta
	if owner.scale.x >= self.growing_max_scale:
		self.shrinking = true
	elif owner.scale.x <= self.growing_min_scale:
		self.shrinking = false
	if self.shrinking:
		owner.scale -= Vector2(1,1) * self.growing_speed
	else:
		owner.scale += Vector2(1,1) * self.growing_speed

func _draw():
	var R = 1.2
	var points = [
		Vector2(0., 1 * R), # R*cos(0), R*sin(0) = R, 0
		Vector2(0.866 * R, -0.5 * R), # R*cos(120deg), R*sin(120deg) = -0.5R, (√3/2)R=0.866R
		Vector2(-0.866 * R, -0.5 * R), # R*cos(240eg), R*sin(240deg) = -0.5R, -(√3/2)R=-0.866R
		]
		
		
	for idx_start in points.size():
		var idx_end = idx_start + 1
		var len = points.size()
		idx_end = idx_end % len
		
		var point_start = points[idx_start]
		var point_end = points[idx_end]
		
		#print(point_start.distance_to(point_end))
		#print(point_start.distance_to(Vector2(0,0)))
		
		var direction = (point_end - point_start).normalized()
		draw_line(point_start*length - direction*width/2, point_end*length + direction*width/2, color, width)
	
