extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	apply_central_force((Vector3.UP * 1000) + (Vector3.RIGHT * randf_range(-500, 200)) + (Vector3.FORWARD * randf_range(-500, 200)))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func hit(): 
	queue_free()

func _on_timer_timeout():
	queue_free()
