extends CanvasLayer

var highscore = null
const SAVE_PATH = "user://highscore.json"
var bestwavetext = null
var bestdamagetext = null
var bestwavetext2 = null
var bestdamagetext2 = null

# Called when the node enters the scene tree for the first time.
func _ready():
	bestwavetext = get_node("BestWave").get_node("BestWaveText")
	bestdamagetext = get_node("BestDamage").get_node("BestDamageText")
	bestwavetext2 = get_node("BestWave2").get_node("BestWaveText")
	bestdamagetext2 = get_node("BestDamage2").get_node("BestDamageText")
	self.load_highscore()
	self.display_highscore()
	

	#get_tree().get_root().get_child(0).get_node("UI")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func display_highscore():	
	var s_wave = "Wave: " + str(highscore["Map_1"]["best_wave"]["wave"]) + "\nDamage: " + str(highscore["Map_1"]["best_wave"]["damage"]) + "\nSeconds: " + str(highscore["Map_1"]["best_wave"]["seconds"])
	var s_damage = "Wave: " + str(highscore["Map_1"]["best_damage"]["wave"]) + "\nDamage: " + str(highscore["Map_1"]["best_damage"]["damage"]) + "\nSeconds: " + str(highscore["Map_1"]["best_damage"]["seconds"])
	var s_wave2 = "Wave: " + str(highscore["Map_2"]["best_wave"]["wave"]) + "\nDamage: " + str(highscore["Map_2"]["best_wave"]["damage"]) + "\nSeconds: " + str(highscore["Map_2"]["best_wave"]["seconds"])
	var s_damage2 = "Wave: " + str(highscore["Map_2"]["best_damage"]["wave"]) + "\nDamage: " + str(highscore["Map_2"]["best_damage"]["damage"]) + "\nSeconds: " + str(highscore["Map_2"]["best_damage"]["seconds"])
	bestwavetext.text = s_wave
	bestdamagetext.text = s_damage
	bestwavetext2.text = s_wave2
	bestdamagetext2.text = s_damage2

func set_default_highscore():
	self.highscore = {
		"Map_1": {
			"best_seconds":  {
				"wave": 0,
				"damage": 0,
				"seconds": 0
			},
			"best_wave":  {
				"wave": 0,
				"damage": 0,
				"seconds": 0
			},
			"best_damage":  {
				"wave": 0,
				"damage": 0,
				"seconds": 0
			}
		},
		"Map_2": {
			"best_seconds":  {
				"wave": 0,
				"damage": 0,
				"seconds": 0
			},
			"best_wave":  {
				"wave": 0,
				"damage": 0,
				"seconds": 0
			},
			"best_damage":  {
				"wave": 0,
				"damage": 0,
				"seconds": 0
			}
		},
	}

func load_highscore():
	if not FileAccess.file_exists(SAVE_PATH):
		print("Save file does not exist")
		set_default_highscore()
		return
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	
	if file:
		var content = file.get_as_text()
		print(content)
		file.close()

		var json = JSON.new()
		var error = json.parse(content)
	
		if error == OK:
			self.highscore = json.data
			#print("Data loaded successfully")
			#print(self.highscore)
		else:
			print("Failed to parse save file")
			set_default_highscore()
	else:
		print("Failed to open file for reading")
		set_default_highscore()
