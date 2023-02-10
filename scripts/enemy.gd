extends Node3D

class_name Enemy

@onready var start = position
@export var health: int


func hit():
	position = Vector3(randf_range(-7, 7), randf_range(-7, 7), start.z)
