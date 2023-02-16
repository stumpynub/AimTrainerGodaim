extends RayCast3D


@export var automatic = false 
@export var shot_time = 0.1

@export var enable_recoil = false 
@export var shots_to_end = 50
@export var horizontal_intensity = 1.0
@export var vertical_intensity = 1.0
@export var curve: Curve

var shot_count = 0 
var recoil_delta = 0
var prev_target = null 
var recoil_offset = Vector3.ZERO
@onready var hit_player = $SFXActionPlayer
@onready var shot_timer = Timer.new()
@onready var start_rot = Global.player.camera.rotation
# Called when the node enters the scene tree for the first time.
func _ready():
	curve.bake_resolution = shots_to_end
	shot_timer.wait_time = shot_time
	shot_timer.one_shot = true
	
	add_child(shot_timer)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if is_valid_collider() and get_collider().has_signal("hit"):
		
		if prev_target != null: 
			if get_collider() == prev_target: 
				prev_target = get_collider()
				prev_target.hovered = true
			else: 
				prev_target.hovered = false
			prev_target = get_collider()
			
		prev_target = get_collider()
	else: 
		if is_instance_valid(prev_target):
			prev_target.hovered = false 
			
			
	if _get_shot_input() and shot_timer.is_stopped(): 
		if enable_recoil: 
			var m = 1.0 / float(shots_to_end)
			shot_count += 1
			recoil_delta += m
			
			recoil_offset.x = delta * vertical_intensity
			recoil_offset.y = (curve.sample(recoil_delta) * delta) * horizontal_intensity
			Global.player.camera.rotation += recoil_offset
		
		var scenario = Global.current_scenario
		shot_timer.start()
		
		if is_valid_collider(): 
			if get_collider().has_signal("hit"): 
				
				get_collider().emit_signal("hit")
				$SFXActionPlayer.play_hit()
				if is_instance_valid(scenario): 
					scenario.hits += 1
			else: 
				if is_instance_valid(scenario): 
					scenario.misses += 1
					
				$SFXActionPlayer.play_miss()
		else: 
			if is_instance_valid(scenario): 
				scenario.misses += 1
			
			$SFXActionPlayer.play_miss()
	elif !_get_shot_input(): 
		recoil_delta = 0 

		
func is_valid_collider(): 
	return is_colliding() and is_instance_valid(get_collider())

func _get_shot_input(): 
	if automatic: 
		return Input.is_action_pressed("action")
	else:
		return Input.is_action_just_pressed("action")
