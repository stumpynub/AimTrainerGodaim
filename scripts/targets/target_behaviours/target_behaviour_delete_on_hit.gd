extends Node

class_name TargetBehaviorDeleteOnHit

@onready var target: Target = get_parent()

func _ready():
	target.hit.connect(_hit)
	
func _hit():
	target.destroy()
