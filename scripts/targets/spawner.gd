extends Node3D

class_name Spawner

@export var rand_min = 0 
@export var rand_max = 0 
@export var amount = 1
@export var scene: PackedScene
@export var target: Target
@export var spawn_area: Vector3
@export var spawn_on_start = false
@export var spawn_on_timeout = false

@onready var timer = Timer.new()
var spawned_objects = []

func _ready(): 
	
	if target != null: 
		pass
		
	add_child(timer)
	timer.autostart = true 
	timer.timeout.connect(_on_timer_timeout)
	
	if spawn_on_start: 
		print("spawned")
		spawn()
	
	if rand_max > 0: 
		timer.wait_time = randf_range(rand_min, rand_max)
		timer.start(timer.wait_time)
		print(timer.wait_time)

func _on_timer_timeout():
	if spawn_on_timeout: 
		timer.wait_time = randf_range(rand_min, rand_max)
		spawn()
	
func spawn():
	for i in range(amount): 
		var obj = scene.instantiate()
		get_parent().call_deferred("add_child",obj)
		obj.set_deferred("global_position", self.global_position)
		obj.set_deferred("start_position", self.global_position)
