extends AudioStreamPlayer

@export var hit_clip: AudioStream
@export var miss_clip: AudioStream

func _ready():
	Global.shoot_player = self 
func play_hit(): 
	stream = hit_clip
	play()
	
func play_miss():
	stream = miss_clip
	play()
	
