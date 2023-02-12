extends Target


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("hit", _hit)


func _hit(): 
	print("hit")
