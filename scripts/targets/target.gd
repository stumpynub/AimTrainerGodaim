extends RigidBody3D

class_name  Target

var hovered = false 

signal hit
signal destroyed

var start_position

var hover_time = 1


func destroy(): 
	destroyed.emit()
	queue_free()
