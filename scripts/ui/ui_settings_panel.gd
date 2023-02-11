extends Panel

var grabbed = false 
var offset: Vector2 
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if grabbed: 
		var new_pos =  get_global_mouse_position() + offset
		global_position = new_pos

func _on_close_button_pressed():
	hide()


func _on_grab_button_button_down():
	move_to_front()
	grabbed = true 
	offset = global_position - get_global_mouse_position()


func _on_grab_button_button_up():
		grabbed = false
