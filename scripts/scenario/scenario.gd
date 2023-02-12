extends Node3D

var total_clicks = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.current_scenario = self 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !Global.player.ui_locked and Input.is_action_just_pressed("action"): 
		total_clicks += 1
