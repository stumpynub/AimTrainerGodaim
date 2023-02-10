extends Control


# Called when the node enters the scene tree for the first time.
func _enter_tree():
	Global.reticle = $Reticle


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$FPSLabel.text = str(Engine.get_frames_per_second())
