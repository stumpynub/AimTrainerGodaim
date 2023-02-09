extends Node3D


var sensitivity = 0.1
@onready var neck = %neck
@onready var camera = %camera
@onready var ray = %Ray

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _unhandled_input(event: InputEvent):
	if ray.is_colliding() == true:
		print("hit")
		if Input.is_action_just_pressed("BUTTON_LEFT"):
			ray.get_collider().get_parent().position.y = randf_range(-1, 1)
			ray.get_collider().get_parent().position.x = randf_range(-1, 1)
			print(ray.get_collider().name)
		
			
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x * 0.0005)
			camera.rotate_x(-event.relative.y * 0.0005)
		
