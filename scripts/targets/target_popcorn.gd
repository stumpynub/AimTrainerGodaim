extends Target


# Called when the node enters the scene tree for the first time.
func _ready():
	apply_central_force((Vector3.UP * randf_range(1000, 1500)) + (Vector3.RIGHT * randf_range(-500, 200)) + (Vector3.FORWARD * randf_range(-500, 200)))
	connect("hit", _hit)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _hit(): 
	queue_free()

func _on_timer_timeout():
	queue_free()

func _on_body_entered(body):
	queue_free()
