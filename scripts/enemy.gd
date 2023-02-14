extends Node3D

class_name Enemy

@onready var start = position
@export var health: int
@onready var boxes: Array = get_tree().get_nodes_in_group("box_enemy")
var close_boxes = []
var can_change = false 
var i = 0 

func _hit():
	
	global_position = Vector3(randf_range(-7, 7), randf_range(-7, 7), start.z)
	
	if boxes.size() <= 1: 
		global_position = Vector3(randf_range(-7, 7), randf_range(-7, 7), start.z)
		return 
	
	while 1: 
		var close_list = []
		var close = false
		
		global_position = Vector3(randf_range(-7, 7), randf_range(-7, 7), start.z)
		
		for box in boxes: 
			var d = global_position.distance_to(box.global_position)
			
			if box != self: 
				close_list.append(d < 2.5)
				
		for i in close_list.size() :
			if close_list[i] == true: 
				global_position = Vector3(randf_range(-7, 7), randf_range(-7, 7), start.z)
				close = true 
	
			if i == int(close_list.size() - 1): 
				if close == false: 
					return
	
