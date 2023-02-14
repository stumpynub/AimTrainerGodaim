extends Node

class_name TargetBehaviourSinPosition

@export var x = false 
@export var y = false 
@export var z = false 

@export var distance = 2
@export var direction: Vector3
@export var speed: float

@onready var target: Target = get_parent()

@onready var start_pos = target.position

var t = 0 

func _ready():
	t = randf_range(0, 1)

func _physics_process(delta):
	t += delta
	if x: 
		target.position.x = start_pos.x + cos(t * speed) * distance
	if y: 
		target.position.y = start_pos.y + sin(t * speed) * distance
	if z: 
		target.position.z = start_pos.z + sin(t * speed) * distance
