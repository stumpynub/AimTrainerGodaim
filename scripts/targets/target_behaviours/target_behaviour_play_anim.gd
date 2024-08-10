extends Node

class_name TargetBehaviourPlayAnim

@export var player: AnimationPlayer
@export var animation: String 
@export var on_ready = false
@export var on_hit = false

@onready var target: Target = get_parent()

func _ready():
	if on_ready: 
		player.play(animation)
	if on_hit: 
		target.connect("hit", _hit)


func _hit(): 
	player.play(animation)
