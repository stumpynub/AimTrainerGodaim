extends Target

class_name DeleteOnHitBehaviour

func _ready():
	connect("hit", _hit)

func _hit(): 
	pass

