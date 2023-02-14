extends Control

var scenario_name = ""
var path = ""
var mouse_hovered = false


func _process(delta):
	if mouse_hovered and Input.is_action_just_pressed("BUTTON_LEFT"): 
		get_tree().change_scene_to_file(path)

func set_item(name, p):
	path = p 
	scenario_name = name
	$Panel/Label.text = scenario_name

func _on_mouse_entered():
	mouse_hovered = true 
	

func _on_mouse_exited():
	mouse_hovered = false
