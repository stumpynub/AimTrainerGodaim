extends TargetBehaviour 

class_name TargetBehaviourRandomPosition

enum e_offset { 
	start_position,
	current_position, 
	world 
}

@export var offset_type: e_offset  = e_offset["current_position"]
@export var distance_check: float = 2
@export var randomize_on_start = false
@export var range: Vector3 = Vector3(7, 7, 7)
@onready var targets: Array = get_tree().get_nodes_in_group("target")

var start_position

var rand_iter = 0

func _ready(): 
	
	start_position = get_parent().global_position
	
	target.connect("hit", _hit)
	
	if randomize_on_start:
		if targets.size() > 1:
			call_deferred("_hit")
		else:
			_randomize()
		
func _process(delta):
	targets = get_tree().get_nodes_in_group("target")
 
func _randomize():
	var offset = Vector3.ZERO
	
	match offset_type: 
		e_offset["start_position"]:
			offset = start_position + Vector3(randf_range(-range.x, range.x), randf_range(-range.y, range.y), randf_range(-range.z, range.z))
		e_offset["current_position"]:
			offset = target.global_position + Vector3(randf_range(-range.x, range.x), randf_range(-range.y, range.y), randf_range(-range.z, range.z))
		e_offset["world"]: 
			offset= Vector3(randf_range(-range.x, range.x), randf_range(-range.y, range.y), randf_range(-range.z, range.z))
			
	target.global_transform.origin = offset
	
func _hit():
	
	_randomize()

	while 1:
		var close_list = []
		var close = false
		rand_iter += 1
		for box in targets: 
			var d = target.global_position.distance_to(box.global_position)

			if box != self: 
				close_list.append(d < distance_check)
		
		for c in close_list:
			if c == true: 
				_randomize()
				close = true 

		if !close:
			target.global_position = target.global_position
			rand_iter = 0
			return 
		
		if rand_iter >= 5000: 
			rand_iter = 0 
			return 
		
		close_list.clear()
