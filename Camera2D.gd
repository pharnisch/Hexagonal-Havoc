extends Camera2D


var min_zoom = 0.5
var max_zoom = 1.2
var zoom_jump_timer = 0
var zoom_jump_time = 10
var zoom_out = true

var rng = RandomNumberGenerator.new()

var rotation_time = null
var rotation_timer = 0
var rotation_amount = 0.05

var traverse_out = true
var traverse_direction = Vector2(rng.randf_range(-1,1), rng.randf_range(-1,1))


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# maybe add more and more visual stuff for higher levels, e.g. wave 1-10 nothing, 11-20 zoom, 21-... rotation, 31-... camera offset, 41..high zoom, 51.high rotation, 61. high offset, 71. high jumps, 81. high color changes
	
	# rotate also movement input from keyboard!
	if get_parent().get_parent().wave_ind >= 10:
		if rotation_time == null:
			rotation_time = self.rng.randf_range(2,10)
			rotation_amount = self.rng.randf_range(-1./rotation_time, 1./rotation_time)
		rotation_timer += delta
		if rotation_timer >= rotation_time:
			rotation_timer -= rotation_time
			rotation_time = self.rng.randf_range(2,10)
			rotation_amount = self.rng.randf_range(-1./rotation_time, 1./rotation_time)
		self.rotation += delta * rotation_amount
		#self.rotation = deg_to_rad(180)
	
	# play with offsit/position change of camera! (only slightly), maybe in random direction for x s, and then back immedeately or go back traverse
	
	if get_parent().get_parent().wave_ind >= 20:
		if self.traverse_direction == Vector2(0,0):
			self.traverse_direction = Vector2(rng.randf_range(-1,1), rng.randf_range(-1,1))
		if traverse_out:
			self.offset += self.traverse_direction * delta * 50
			if self.offset.length() >= 300:
				traverse_out = false
		else:
			self.offset -= self.traverse_direction * delta * 50
			if self.offset.length() <= 5:
				traverse_out = true
				traverse_direction = Vector2(rng.randf_range(-1,1), rng.randf_range(-1,1))
	
	if get_parent().get_parent().wave_ind >= 5:
		if zoom_out:
			self.zoom -= delta * Vector2(1,1) * 0.05
			if self.zoom.x < min_zoom:
				zoom_out = false
		else:
			self.zoom += delta * Vector2(1,1) * 0.05
			if self.zoom.x > max_zoom:
				zoom_out = true
	
	if get_parent().get_parent().wave_ind >= 25:
		zoom_jump_timer += delta
		if zoom_jump_timer >= zoom_jump_time:
			zoom_jump_timer -= zoom_jump_time
			zoom_out = !zoom_out
			self.zoom = Vector2(1.7,1.7) - self.zoom
