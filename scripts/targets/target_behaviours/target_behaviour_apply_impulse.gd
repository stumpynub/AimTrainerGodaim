extends Node

class_name TargetBehaviourApplyImpulse

@export var impulse: Vector3
@onready var target: Target = get_parent()

func _ready():
	target.apply_central_impulse(impulse)
	
