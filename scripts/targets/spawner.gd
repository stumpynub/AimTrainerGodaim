extends Node3D

@export var scene: PackedScene



func _on_timer_timeout():
	var obj = scene.instantiate()
	get_parent().add_child(obj)
	obj.global_position = self.global_position
	
