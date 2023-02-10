extends Node3D
@onready var start = position

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event):
	pass


func _on_area_3d_area_entered(area):
	pass
	
func hit():
	position = Vector3(randf_range(-.8, .8), randf_range(-.8, .8), start.z)
