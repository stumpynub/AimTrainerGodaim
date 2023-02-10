extends Node3D

class_name Enemy

@onready var start = position
@export var health: int


func hit():
	position = Vector3(randf_range(-6, 6), randf_range(-2, 3), start.z)
