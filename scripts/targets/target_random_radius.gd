extends Target

@export var distance_check: float = 2
@export var randomize_on_start = false
@export var area: Vector3 = Vector3(7, 7, 7)
@onready var start = position
@onready var targets: Array = get_tree().get_nodes_in_group("target")
@export var use_start_offset = true

var rand_iter = 0

func _ready(): 
	connect("hit", _hit)
	
	if randomize_on_start:
		if targets.size() > 1:
			call_deferred("_hit")
		else:
			_randomize()
		
func _enter_tree():
	start_position = global_position

func _process(delta):
	targets = get_tree().get_nodes_in_group("target")

func _randomize():

	if use_start_offset:
		global_position = start_position + Vector3(randf_range(-area.x, area.x), randf_range(-area.y, area.y), randf_range(-area.z, area.z))
	else:
		global_position = Vector3(randf_range(-area.x, area.x), randf_range(-area.y, area.y), randf_range(-area.z, area.z))


func _hit():
	
	_randomize()
	
	if targets.size() <= 1:
		return 

	while 1:
		var close_list = []
		var close = false
		rand_iter += 1
		for box in targets: 
			var d = global_position.distance_to(box.global_position)

			if box != self: 
				close_list.append(d < distance_check)
		
		for c in close_list:
			if c == true: 
				_randomize()
				close = true 

		if !close:
			global_position = global_position
			rand_iter = 0
			return 
		
		
		if rand_iter >= 5000: 
			rand_iter = 0 
			return 
		
		close_list.clear()
