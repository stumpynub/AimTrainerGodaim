extends Control

@onready var scenarios_container = %ScenariosVContainer
@onready var ezcfg: EzCfg = $EzCfg
@onready var customize_popup = %CustomizeMenuButton.get_popup()
@onready var settings_popup = %SettingsMenuButton.get_popup()

var settings_panels = []


# Called when the node enters the scene tree for the first time.
func _ready():
	
	customize_popup.id_pressed.connect(customize_pressed)
	settings_popup.id_pressed.connect(settings_pressed)
	var dir = "res://scenes/scenerios/"
	
	if DirAccess.dir_exists_absolute("res://scenes/scenerios/"): 
		for file in DirAccess.get_files_at("res://scenes/scenerios/"):

			var instance = load("res://scenes/ui/ui_senereo_item.tscn")
			var name = file.replace("_", " ")
			var path = dir + str(file)
			print(path)
			name = name.replace(".tscn", "")
			name = name.replace("scenario ", "")
			instance = instance.instantiate()
			instance.set_item(name, path)
			scenarios_container.add_child(instance)
	
	init_values()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("menu"):
		toggle_menu()


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
	
	
func init_values(): 
	%SensitivitySlider.value = ezcfg.get_value("player", "sensitivity", 0.2)
	%ReticleImagesOption.selected = ezcfg.get_value("reticle", "image")
	%ColorPickerButton.color = ezcfg.get_value("reticle", "color", Color(1,1,1,1))
	%ReticleScaleSlider.value =  ezcfg.get_value("reticle", "scale", 0.2)
	%FullscreenCheckbox.button_pressed = ezcfg.get_value("graphics", "fullscreen", false)
	%VsyncCheckbox.button_pressed = ezcfg.get_value("graphics", "vsync", false)
	
	Global.reticle.texture = %ReticleImagesOption.get_item_icon(ezcfg.get_value("reticle", "image"))
	Global.reticle.modulate = %ColorPickerButton.color
	Global.reticle.scale.x = ezcfg.get_value("reticle", "scale")
	Global.reticle.scale.y = ezcfg.get_value("reticle", "scale")
	
	update_reticle_preview()
	
func update_reticle_preview(): 
	%ReticlePreview.modulate = %ColorPickerButton.color
	%ReticlePreview.texture =  %ReticleImagesOption.get_item_icon(ezcfg.get_value("reticle", "image"))

func _on_reticle_menu_button_pressed():
	select_panel($SettingsContainer/ReticlePanel)

func _on_reticle_menu_button_2_pressed():
	select_panel($SettingsContainer/ControlsPanel)
	
func _on_scenarios_menu_button_pressed():
		select_panel($SettingsContainer/ScenariosPanel)

func _on_stats_pressed():
	select_panel($SettingsContainer/StatsPanel)


func customize_pressed(id): 
	match id: 
		0: 
			select_panel($SettingsContainer/ReticlePanel)
		1: 
			select_panel($SettingsContainer/EnviromentPanel)
			
func settings_pressed(id): 
	match id: 
		0: 
			select_panel($SettingsContainer/ControlsPanel)
		
		1: 
			select_panel($SettingsContainer/VideoPanel)
			
func select_panel(panel): 
	panel.show()
	panel.move_to_front()
	panel.global_position.x = get_viewport().size.x / 2 - panel.size.x / 2
	panel.global_position.y = (get_viewport().size.y / 2) - panel.size.y / 2
	

func toggle_menu(): 
	if visible: 
		hide()
		Global.player.ui_locked = false
	else: 
		show()
		Global.player.ui_locked = true

func _on_scenarios_search_text_changed(new_text):
	for s in scenarios_container.get_children(): 
		if s.get("scenario_name"): 
			if str(s.scenario_name).contains(new_text.strip_edges()) or new_text == "":
				s.show()
			else: 
				s.hide()


func _on_fullscreen_checkbox_toggled(button_pressed):
	ezcfg.save_value("graphics", "fullscreen", button_pressed)
	if button_pressed == true: 
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else: 
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_vsync_checkbox_toggled(button_pressed):
	if button_pressed == true: 
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else: 
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		
	ezcfg.save_value("graphics", "vsync", button_pressed)
