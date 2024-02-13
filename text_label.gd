extends Label

var living_time = 0.5
var living_timer = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.living_timer += delta
	if self.living_timer >= self.living_time:
		self.queue_free()

func change_color(color : Color):
	#var red = Color(1.0,0.0,0.0,1.0)
	self.set("theme_override_colors/font_color", color)

func change_size(dmg):
	# size should go from 5 to 50 for dmg from 1 to 999 (CAP)
	# 5 +  * 1 = 5; 5 + 0,04 * 1000 = 45
	#var size = 10 + 0.04 * dmg
	# from 4 dmg to 100 dmg:
	var size = 15 + 0.05 * dmg
	add_theme_font_size_override("font_size", size)
	
func set_value(dmg):
	self.text = str(round(dmg))
	self.change_size(dmg)
