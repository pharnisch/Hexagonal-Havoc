extends Control

@export var color := Color.WHITE
@export var width := 20
@export var length = 50
@export var rotation_speed = 1

func _ready():
	self.rotation = 0

func _physics_process(delta):
	self.rotation -= rotation_speed * delta

func _draw():
	var points = [
		Vector2(1., 0),
		Vector2(1./2., sqrt(3)/2.),
		Vector2(-1./2., sqrt(3)/2.),
		Vector2(-1., 0),
		Vector2(-1./2., -sqrt(3)/2.),
		Vector2(1./2., -sqrt(3)/2.),
		]
		
	for idx_start in points.size():
		var idx_end = idx_start + 1
		var len = points.size()
		idx_end = idx_end % len
		
		if idx_end <= 5:
			var point_start = points[idx_start]
			var point_end = points[idx_end]
			
			var direction = (point_end - point_start).normalized()
			draw_line(point_start*length - direction*width/4, point_end*length + direction*width/4, color, width)
	
	
#(1,0),(−1,0),(1/2,3–√/2),(−1/2,3–√/2),(1/2,−3–√/2),(−1/2,−3–√/2)
