extends Control

@onready var scenarios_container = %ScenariosVContainer
@onready var ezcfg: EzCfg = $EzCfg
@onready var customize_popup = %CustomizeMenuButton.get_popup()
@onready var settings_popup = %SettingsMenuButton.get_popup()


var scenarios_dir =  "res://scenes/scenerios/"

var actions_dir = "res://assets/audio/sfx/action/"
var supported_audio_formats = ["ogg", "wav"]

var settings_panels = []

var opened = true

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false
	toggle_menu()
	
	## Connect menu bar buttons
	## 
	customize_popup.id_pressed.connect(customize_pressed)
	settings_popup.id_pressed.connect(settings_pressed)
	
	
	## Get any files in in the sfx dir 
	## and add an option for the hit and miss option buttons 

	if DirAccess.dir_exists_absolute(actions_dir): 
		for file in DirAccess.get_files_at(actions_dir):
			for format in supported_audio_formats: 
				if file.ends_with(format): 
					%HitSFXOptionButton.add_item(file)
					%MissSFXOptionButton.add_item(file)
	
	
	## Adds 'ui_scenario_item' for each file in
	## the scenarios scene folder -> res/scenes/scenarios
	
	if DirAccess.dir_exists_absolute(scenarios_dir): 
		for file in DirAccess.get_files_at("res://scenes/scenerios/"):

			var instance = load("res://scenes/ui/ui_scenario_item.tscn")
			var name = file.replace("_", " ")
			var path = scenarios_dir + str(file)
			name = name.replace(".tscn", "")
			name = name.replace("scenario ", "")
			instance = instance.instantiate()
			instance.set_item(name, path)
			scenarios_container.add_child(instance)
	####
	

	call_deferred("init_values")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("menu"):
		toggle_menu()
		
	

func toggle_menu(): 
	var s = $SettingsContainer
	if opened: 
		for child in s.get_children(): 
			
			if child.get("pinned") == true:
				if child.pinned == true: 
					child.show()
			else: 
				child.hide()
		opened = false 
		Global.player.ui_locked = false
		get_tree().paused = false
	else: 
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED
		for child in s.get_children(): 
			if child.get("prev_opened") != null: 
				if child.prev_opened == true: 
					child.show()
				else: 
					child.hide()
			else: 
				child.show()
		Global.player.ui_locked = true
		opened = true 
		get_tree().paused = true


func update_reticle_preview(): 
	%ReticlePreview.modulate = %ColorPickerButton.color
	%ReticlePreview.texture =  %ReticleImagesOption.get_item_icon(ezcfg.get_value("reticle", "image"))

func init_values(): 
	%SensitivitySlider.value = ezcfg.get_value("player", "sensitivity", 0.2)
	%ReticleImagesOption.selected = ezcfg.get_value("reticle", "image")
	%ColorPickerButton.color = ezcfg.get_value("reticle", "color", Color(1,1,1,1))
	%ReticleScaleSlider.value =  ezcfg.get_value("reticle", "scale", 0.2)
	%FullscreenCheckbox.button_pressed = ezcfg.get_value("graphics", "fullscreen", false)
	%VsyncCheckbox.button_pressed = ezcfg.get_value("graphics", "vsync", false)
	
	# SFX Customize
	%HitSFXOptionButton.selected = ezcfg.get_value("SFX", "hit", 0)
	%MissSFXOptionButton.selected = ezcfg.get_value("SFX", "miss", 0)
	
	Global.reticle.texture = %ReticleImagesOption.get_item_icon(ezcfg.get_value("reticle", "image"))
	Global.shoot_player.hit_clip = load(actions_dir + %HitSFXOptionButton.get_item_text(ezcfg.get_value("SFX", "hit", 0)))
	Global.shoot_player.miss_clip = load(actions_dir + %MissSFXOptionButton.get_item_text(ezcfg.get_value("SFX", "miss", 0)))
	
	Global.reticle.modulate = %ColorPickerButton.color
	Global.reticle.scale.x = ezcfg.get_value("reticle", "scale")
	Global.reticle.scale.y = ezcfg.get_value("reticle", "scale")

	update_reticle_preview()
	
func _on_quit_button_pressed():
	get_tree().quit()

func customize_pressed(id): 
	match id: 
		0: 
			select_panel($SettingsContainer/ReticlePanel)
		1: 
			select_panel($SettingsContainer/EnviromentPanel)
		2: 
			select_panel($SettingsContainer/SFXPanel)
			
func settings_pressed(id): 
	match id: 
		0: 
			select_panel($SettingsContainer/ControlsPanel)
		
		1: 
			select_panel($SettingsContainer/VideoPanel)
	
func select_panel(panel): 
	panel.show()
	panel.prev_opened = true
	panel.move_to_front()
	panel.global_position.x = get_viewport().size.x / 2 - panel.size.x / 2
	panel.global_position.y = (get_viewport().size.y / 2) - panel.size.y / 2
	


## RETICLE PANEL #############################################
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

func _on_reticle_menu_button_pressed():
	select_panel($SettingsContainer/ReticlePanel)

func _on_reticle_menu_button_2_pressed():
	select_panel($SettingsContainer/ControlsPanel)

########################################################




## SCENARIOS PANEL ###########################################
func _on_scenarios_menu_button_pressed():
		select_panel($SettingsContainer/ScenariosPanel)


func _on_scenarios_search_text_changed(new_text):
	for s in scenarios_container.get_children(): 
		if s.get("scenario_name"): 
			if str(s.scenario_name).to_lower().contains(new_text.strip_edges().to_lower()) or new_text == "":
				s.show()
			else: 
				s.hide()

###########################################################





## CONTROL SETTINGS ###################################
func _on_sensitivity_spin_box_value_changed(value):
	%SensitivitySlider.value = value


func _on_sensitivity_slider_value_changed(value):
	ezcfg.save_value("player", "sensitivity", value)

	if is_instance_valid(Global.player): 
		Global.player.mouse_sensitivity = value
	
	%SensitivitySpinBox.value = value 

############################################




## GRAPHIC SETTINGS #####################################
func _on_fullscreen_checkbox_toggled(button_pressed):
	ezcfg.save_value("graphics", "fullscreen", button_pressed)
	if button_pressed == true: 
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else: 
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)



func _on_vsync_checkbox_toggled(button_pressed):
	ezcfg.save_value("graphics", "vsync", button_pressed)
	if button_pressed == true: 
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else: 
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

#######################################


 
## STATS PANEL ###########################################

func _on_stats_pressed():
	select_panel($SettingsContainer/StatsPanel)


## SFX PANEL #############################################
func _on_action_option_button_item_selected(index):
	print("found")
	if is_instance_valid(Global.shoot_player): 
		if index == 0:
			Global.shoot_player.hit_clip = null 
		else: 
			Global.shoot_player.hit_clip = load(actions_dir + %HitSFXOptionButton.get_item_text(index))
		ezcfg.save_value("SFX", "hit", index)
		
func _on_miss_sfx_option_button_item_selected(index):
	if is_instance_valid(Global.shoot_player): 
		if index == 0: 
			Global.shoot_player.miss_clip = null
		else: 
			Global.shoot_player.miss_clip = load(actions_dir + %MissSFXOptionButton.get_item_text(index))
		
		ezcfg.save_value("SFX", "miss", index)
		
##################################################################################################
