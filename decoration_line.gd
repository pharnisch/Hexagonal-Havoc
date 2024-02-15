extends Control

@export var color := Color.WHITE
@export var width := 10
#@export var length = 50
@export var rotation_speed = 0.
@export var growing_speed := 0.
@export var A = Vector2(0,-50)
@export var B = Vector2(0,50)


func _ready():
	self.rotation = 0

func _process(delta):
	pass
	#owner.rotation -= rotation_speed * delta
	#owner.scale += Vector2(1,1) * self.growing_speed

func _draw():
	draw_line(A, B, color, width)
	
