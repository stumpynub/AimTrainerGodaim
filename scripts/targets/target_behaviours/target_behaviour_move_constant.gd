extends TargetBehaviour

class_name TargetBehaviourMoveConstant

@export var direction: Vector3
@export var speed: float = 1

func _physics_process(delta):
	target.global_position += direction.normalized() * (delta * speed)
