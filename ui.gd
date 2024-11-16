extends CanvasLayer

var lifebar = null
var timer = 0
var saveInterval = 5
var saveIntervalTimer = 5
const SAVE_PATH = "user://highscore.json"
var highscore = null

# Called when the node enters the scene tree for the first time.
func _ready():
	owner.get_node("Player").get_node("HealthPool").player_health_change.connect(health_change)
	owner.get_node("Player").on_exp_change.connect(on_exp_change)
	self.lifebar = get_node("LifeBar")
	
	self.load_highscore()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	saveIntervalTimer -= delta
	if saveIntervalTimer <= 0:
		saveIntervalTimer += saveInterval
		self.save_highscore()
		
	timer += delta
	self.get_node("TimeText").text = "Seconds: " + str(round(timer))
	self.get_node("Wave").text = "Wave: " + str(get_parent().wave_ind + 1)
	self.get_node("Damage").text = "Damage: " + str(round(get_parent().total_damage_done))
	
func save_highscore():
	var seconds = int(self.get_node("TimeText").text)
	var wave = int(self.get_node("Wave").text)
	var damage = int(self.get_node("Damage").text)
	
	var scene_name = get_tree().current_scene.name
	
	var data = self.highscore
	#if data["best_seconds"]["seconds"] < seconds:
#		data["best_seconds"] = {#
#			"wave": wave,
#			"damage": damage,
#			"seconds": seconds
#		}
	if data[scene_name]["best_wave"]["wave"] < wave:
		data[scene_name]["best_wave"] = {
			"wave": wave,
			"damage": damage,
			"seconds": seconds
		}
	if data[scene_name]["best_damage"]["damage"] < damage:
		data[scene_name]["best_damage"] = {
			"wave": wave,
			"damage": damage,
			"seconds": seconds
		}
		
	#print(data)
	self.highscore = data
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		#print("Data saved successfully to: ", SAVE_PATH)
		file.close()
	else:
		print("Failed to open file for saving")
	
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


func health_change(health, max_health):
	lifebar.value = health
	lifebar.max_value = max_health
	self.lifebar.get_node("LifeText").text = str(round(health)) + "/" + str(round(max_health))
	
func on_exp_change(lvl, exp, exp_for_next_skill, total_exp):
	self.get_node("ExpBar").value = exp
	self.get_node("ExpBar").max_value = exp_for_next_skill
	self.get_node("ExpBar").get_node("ExpText").text = str(snapped(exp,0.1)) + "/" + str(round(exp_for_next_skill)) + " (LVL: " + str(lvl) + ")"# +", TOTAL XP: " + str(round(total_exp)) + ")"
