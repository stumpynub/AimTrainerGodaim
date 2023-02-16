extends Panel

class_name UISettingsPanel

@export var pinned = false 
@export var pinned_container: Control

@onready var start_container = get_parent()
@onready var init_offset_right = offset_right
@onready var init_offset_bottom = offset_bottom
@onready var init_scale = scale
var prev_opened = false 
var grabbed = false 
var scale_grabbed = false 
var offset: Vector2 
var scale_mouse_pos = Vector2.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var vp_size = get_viewport().size
	if grabbed: 
		var new_pos =  get_global_mouse_position() + offset
		
		if new_pos.y >= 0 and new_pos.y + size.y <= vp_size.y: 
			global_position.y = new_pos.y
		if new_pos.x >= 0 and new_pos.x + size.x <= vp_size.x: 
			global_position.x = new_pos.x
		
	if scale_grabbed: 
		var offset = scale_mouse_pos - get_global_mouse_position()
		
		offset_right = init_offset_right - offset.x 
		offset_bottom = init_offset_bottom - offset.y
		#anchor_bottom = init_anchor_bottom - (offset.y / 1000)
	_process_overload()
	
func _on_close_button_pressed():
	prev_opened = false  
	pinned = false 
	$HBoxContainer/PinButton.button_pressed = false
	hide()


func _on_grab_button_button_down():
	move_to_front()
	grabbed = true 
	offset = global_position - get_global_mouse_position()

func _on_grab_button_button_up():
		grabbed = false

func _on_size_button_button_down():
	scale_mouse_pos = get_global_mouse_position()
	init_offset_right = offset_right
	init_offset_bottom = offset_bottom
	scale_grabbed = true 

func _on_size_button_button_up():
	scale_grabbed = false 

func _on_pin_button_toggled(button_pressed):
	if button_pressed == true: 
		pinned = true 
	else: 
		pinned = false

func _process_overload(): 
	pass
