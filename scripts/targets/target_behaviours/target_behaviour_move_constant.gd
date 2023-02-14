extends Node

class_name TargetBehaviourMoveConstant

@export var direction: Vector3
@export var speed: float = 1

@onready var target: Target = get_parent()

func _physics_process(delta):
	target.global_position += direction.normalized() * (delta * speed)
