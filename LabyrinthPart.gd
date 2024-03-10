extends Node2D

@export var color := Color.DIM_GRAY
@export var width := 20
@export var length = 50
@export var rotation_speed = 1
@export var rotation_start = 0

func _ready():
	self.rotation = rotation_start

func _physics_process(delta):
	self.rotation -= rotation_speed * delta * 0.1

func _draw():
	var points = [
		Vector2(10,10),
		Vector2(10,-10),
		Vector2(-10,-10),
		Vector2(-10,10),
		#Vector2(10,10),
		#Vector2(-10,10),
		#Vector2(-10,-10),
		#Vector2(10,-10),
		#Vector2(10,-9),
		#Vector2(-9,-9),
		#Vector2(-9,9),
		#Vector2(10,9),
		]
		
	for idx_start in points.size():
		var idx_end = idx_start + 1
		var len = points.size()
		idx_end = idx_end % len
		
		if idx_end <= 2:
			var point_start = points[idx_start]
			var point_end = points[idx_end]
			
			var direction = (point_end - point_start).normalized()
			draw_line(point_start*length - direction*width/2, point_end*length + direction*width/2, color, width)
	
