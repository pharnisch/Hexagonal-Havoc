extends Node2D

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

func _process(delta):
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
	var points = [
		Vector2(0., 1.22),
		Vector2(1., -0.73205),
		Vector2(-1., -0.73205),
		]
		
		
	for idx_start in points.size():
		var idx_end = idx_start + 1
		var len = points.size()
		idx_end = idx_end % len
		
		var point_start = points[idx_start]
		var point_end = points[idx_end]
		
		var direction = (point_end - point_start).normalized()
		draw_line(point_start*length - direction*width/2, point_end*length + direction*width/2, color, width)
	
