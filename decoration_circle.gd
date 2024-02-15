extends Control

#@export var color := Color.WHITE
@export var width := 5
@export var length = 20

func _draw():
	draw_circle(Vector2(0, 0), self.length, Color.WHITE)
	
	
