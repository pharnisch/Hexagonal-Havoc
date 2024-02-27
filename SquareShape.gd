extends Node2D

@export var color := Color.WHITE
@export var width := 20
@export var length = 50
@export var rotation_speed = 1
@export var growing_speed := 0.05

func _ready():
	self.rotation = 0

func _physics_process(delta):
	owner.rotation -= rotation_speed * delta
	owner.scale += Vector2(1,1) * self.growing_speed
	if owner.scale.x < 0:
		owner.queue_free()

func _draw():
	var points = [
		Vector2(1., 1),
		Vector2(-1., 1),
		Vector2(-1, -1),
		Vector2(1, -1),
		]
		
	for idx_start in points.size():
		var idx_end = idx_start + 1
		var len = points.size()
		idx_end = idx_end % len
		
		var point_start = points[idx_start]
		var point_end = points[idx_end]
		
		var direction = (point_end - point_start).normalized()
		draw_line(point_start*length - direction*width/2, point_end*length + direction*width/2, color, width)
	
