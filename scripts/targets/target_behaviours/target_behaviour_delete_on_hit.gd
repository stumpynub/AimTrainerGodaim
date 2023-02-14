extends Node

class_name TargetBehaviourDeleteOnHit

@onready var target: Target = get_parent()

func _ready():
	target.hit.connect(_hit)
	
func _hit():
	target.queue_free()
