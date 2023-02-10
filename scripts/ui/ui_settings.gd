extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("menu"):
		if visible: 
			get_parent().ui_locked = false 
			visible = false 
		else: 
			get_parent().ui_locked = true 
			visible = true


func _on_h_slider_value_changed(value):
	Global.reticle.scale.x = value
	Global.reticle.scale.y = value


func _on_reticle_images_option_item_selected(index):
	Global.reticle.texture = %ReticleImagesOption.get_item_icon(index)


func _on_color_picker_button_color_changed(color):
	Global.reticle.modulate = color


func _on_quit_button_pressed():
	get_tree().quit()


func _on_sensitivity_slider_value_changed(value):
	Global.player.mouse_sensitivity = value


func _on_vsync_check_box_toggled(button_pressed):
	if button_pressed == true: 
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else: 
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
