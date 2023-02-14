extends Node

class_name TargetBehaviourHoverTime



@onready var target: Target = get_parent()

var time = 0
var max_time = 0 
var t = 0 

signal max_time_reached

func _physics_process(delta):
	if target.hovered: 
		time += delta
		print(time)
	else: 
		time = 0
	
	if max_time != 0: 
		if time >= max_time: 
			emit_signal("max_time_reached")
