extends Node

class_name TargetBehaviourTrackerBot

@onready var target: Target = get_parent()

var hits = 0
var max_time = 0 
var miss = 0
var accuracy = 0

func _physics_process(delta):
	if target.hovered:
		if Input.is_mouse_button_pressed(1):
			hits += delta
			
	if Input.is_mouse_button_pressed(1):
			miss += delta
			
			
func _process(delta):
	if hits >= 1:
		accuracy = hits * 100 / miss
		
