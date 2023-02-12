extends Node3D

class_name Spawner

@export var amount = 1
@export var scene: PackedScene
@export var spawn_area: Vector3
@export var spawn_on_start = false
@export var spawn_on_timeout = false

var spawned_objects = []

func _ready(): 
	if spawn_on_start: 
		spawn()

func _on_timer_timeout():
	if spawn_on_timeout: 
		spawn()
	
func spawn():
	for i in range(amount): 
		var obj = scene.instantiate()
		get_parent().call_deferred("add_child",obj)
		obj.set_deferred("global_position", self.global_position)

