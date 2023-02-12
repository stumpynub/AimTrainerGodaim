extends PathFollow3D

@export_range(0, 1) var speed = 0.2

var dir = 1
var r = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if progress_ratio >= 1: 
		dir = -1 
		
	elif progress_ratio <= 0: 
		dir = 1 
		
	
func _physics_process(delta):
	if r <= 0: 
		progress_ratio += delta * dir * speed
	else: 
		progress_ratio -= delta * dir * speed
		
func _on_timer_timeout():
	r = randf_range(-3, 3)

