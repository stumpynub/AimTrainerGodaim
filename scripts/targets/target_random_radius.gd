extends Target


@onready var start = position
@onready var targets: Array = get_tree().get_nodes_in_group("target")

func _ready(): 
	print(targets)
	connect("hit", _hit)

func _hit():
	print("hi")
	global_position = Vector3(randf_range(-7, 7), randf_range(-7, 7), start.z)
	
	if targets.size() <= 1: 
		global_position = Vector3(randf_range(-7, 7), randf_range(-7, 7), start.z)
		return 
	
	while 1: 
		var close_list = []
		var close = false
		
		global_position = Vector3(randf_range(-7, 7), randf_range(-7, 7), start.z)
		
		for box in targets: 
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
	

