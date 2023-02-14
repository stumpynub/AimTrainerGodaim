extends Node3D
var total = 0 
var hits = 0 
var misses = 0 
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.current_scenario = self 
