extends Node

class_name RandomRespawn

@export var scene: PackedScene
@onready var target: Target = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _respawn():
	var obj = scene.instantiate()
	get_parent().call_deferred("add_child",obj)
	obj.set_deferred("global_position", self.global_position)
	obj.set_deferred("start_position", self.global_position)
