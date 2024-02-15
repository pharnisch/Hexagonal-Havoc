extends CanvasLayer

var lifebar = null

# Called when the node enters the scene tree for the first time.
func _ready():
	owner.get_node("Player").get_node("HealthPool").player_health_change.connect(health_change)
	owner.get_node("Player").on_exp_change.connect(on_exp_change)
	self.lifebar = get_node("LifeBar")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass

func health_change(health, max_health):
	lifebar.value = health
	lifebar.max_value = max_health
	self.lifebar.get_node("LifeText").text = str(round(health)) + "/" + str(round(max_health))
	
func on_exp_change(lvl, exp, exp_for_next_skill, total_exp):
	self.get_node("ExpBar").value = exp
	self.get_node("ExpBar").max_value = exp_for_next_skill
	self.get_node("ExpBar").get_node("ExpText").text = str(round(exp)) + "/" + str(round(exp_for_next_skill)) + " (LVL: " + str(lvl) + ")"# +", TOTAL XP: " + str(round(total_exp)) + ")"
