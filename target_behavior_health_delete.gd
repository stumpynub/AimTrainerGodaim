extends Node

class_name TargetBehaviorHealthDelete

@export var health = 5
@onready var target: Target = get_parent()
@onready var timer = $Timer2

	
func _process(delta):
	if target.hovered:
		if Input.is_mouse_button_pressed(1):
			health -= delta
	if health <= 0.1:
		target.visible = false
	if health < 2.5 && target.visible == false:
		health += delta
		if health >= 2.5:
			target.visible = true
			health = 5
	print(health)
