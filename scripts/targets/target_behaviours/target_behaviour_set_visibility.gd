extends TargetBehaviour

class_name TargetBehaviourSetVisibility

@export var visible = false 
@export var on_hit = true 

func _ready():
	target.hit.connect(_hit)


func _hit(): 
	target.visible = visible
