extends Node

var player = null 
var reticle = null 
var current_scenario = null
var shoot_player = null

@onready var start_time = Time.get_ticks_msec()
var time = 0 

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta):
	time = Time.get_ticks_msec() - start_time

func get_elapsed_time_str(): 
	var total_secs = (time / 600)
	var ms = (time / 60) % 10
	var secs = total_secs % 60
	var mins = (total_secs / 60) % 60
	var hrs = (mins / 60) % 60
	
	return "%s:%s:%s:%s" % [hrs, mins, secs, ms]

func reset_time(): 
	start_time = Time.get_ticks_msec()

func change_scene(scene): 
	get_tree().change_scene_to_file(scene)
