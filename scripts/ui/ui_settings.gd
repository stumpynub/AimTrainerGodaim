extends Control

@onready var scenerios_container = $TabContainer/Scenerios/SceneriosVContainer
@onready var ezcfg: EzCfg = $EzCfg




# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	
	var dir = "res://scenes/scenerios/"
	if DirAccess.dir_exists_absolute("res://scenes/scenerios/"): 
		for file in DirAccess.get_files_at("res://scenes/scenerios/"):

			var instance = load("res://scenes/ui/ui_senereo_item.tscn")
			var name = file.replace("_", " ")
			var path = dir + str(file)
			print(path)
			name = name.replace(".tscn", "")
			name = name.replace("scenerio ", "")
			instance = instance.instantiate()
			instance.set_item(name, path)
			scenerios_container.add_child(instance)
	
	init_values()


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
	ezcfg.save_value("reticle", "scale", value)


func _on_reticle_images_option_item_selected(index):
	update_reticle_preview()
	print("selected")
	ezcfg.save_value("reticle", "image", index)
	Global.reticle.texture = %ReticleImagesOption.get_item_icon(index)

func _on_color_picker_button_color_changed(color):
	update_reticle_preview()
	if is_instance_valid(Global.reticle): 
	
		Global.reticle.modulate = color
	ezcfg.save_value("reticle", "color", color)
	

func _on_quit_button_pressed():
	get_tree().quit()


func _on_sensitivity_slider_value_changed(value):
	ezcfg.save_value("player", "sensitivity", value)

	if is_instance_valid(Global.player): 
		Global.player.mouse_sensitivity = value
	
func _on_vsync_check_box_toggled(button_pressed):
	if button_pressed == true: 
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else: 
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		
	ezcfg.save_value("graphics", "vsync", button_pressed)

func init_values(): 
	%SensitivitySlider.value = ezcfg.get_value("player", "sensitivity", 0.2)
	%ReticleImagesOption.selected = ezcfg.get_value("reticle", "image")
	%ColorPickerButton.color = ezcfg.get_value("reticle", "color", Color(1,1,1,1))
	%ReticleScaleSlider.value =  ezcfg.get_value("reticle", "scale", 0.2)
	
	Global.reticle.texture = %ReticleImagesOption.get_item_icon(ezcfg.get_value("reticle", "image"))
	Global.reticle.modulate = %ColorPickerButton.color
	Global.reticle.scale.x = ezcfg.get_value("reticle", "scale")
	Global.reticle.scale.y = ezcfg.get_value("reticle", "scale")
	
	update_reticle_preview()
func _on_reticle_menu_button_pressed():
	$ReticlePanel.show()
	$ReticlePanel.move_to_front()

func update_reticle_preview(): 
	%ReticlePreview.modulate = %ColorPickerButton.color
	%ReticlePreview.texture =  %ReticleImagesOption.get_item_icon(ezcfg.get_value("reticle", "image"))

func _on_reticle_menu_button_2_pressed():
	$ControlsPanel.show()
	$ControlsPanel.move_to_front()
