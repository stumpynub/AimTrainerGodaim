extends AudioStreamPlayer

@export var hit_clip: AudioStream
@export var mis_clip: AudioStream

func play_hit(): 
	stream = hit_clip
	play()
	
func play_miss():
	stream = mis_clip
	play()
	
