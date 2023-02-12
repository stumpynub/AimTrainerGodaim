extends Node3D

class_name Enemy

@onready var start = position
@export var health: int
@onready var boxes: Array = get_tree().get_nodes_in_group("box_enemy")

func _ready():
	print(boxes)

func hit():
	#print('hit')
	for box in boxes:
		if is_collided(self, box):
			position = Vector3(randf_range(-7, 7), randf_range(-7, 7), start.z)
			
func is_collided(box1, box2):
	print("in collided")
	var distance = box1.position.distance_to(box2.position)
	var combined_size = 8
	if distance <= combined_size / 2:
		return true
	return false
