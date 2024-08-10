extends Node

class_name TargetBehaviourTrackBot

@onready var target: Target = get_parent()

var hits = 0
var max_time = 0 
var t = 0
var miss = 0
var accuracy = 0

signal max_time_reached

func _physics_process(delta):
	if target.hovered:
		if Input.is_mouse_button_pressed(1):
			hits += delta
			
	if Input.is_mouse_button_pressed(1):
			miss += delta
	
	if max_time != 0: 
		if hits >= max_time: 
			emit_signal("max_time_reached")
			
func _process(delta):
	if hits >= 1:
		accuracy = hits * 100 / miss
