extends Node2D

#@export var color := Color.WHITE
@export var width := 5
@export var length = 20
var color = Color.WHITE

func _draw():
	draw_circle(Vector2(0, 0), self.length, color)
	
	
