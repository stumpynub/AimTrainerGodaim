extends CharacterBody3D


enum e_movement_state { 
	none, 
	crouch, 
	ground_walk,
	ground_crouch,  
	air, 
	climb, 
	swim
}


@export var fire_rate = 0.3
@export var camera: Camera3D
@export var player_area: Area3D
@export var enable_movement = false
@export_range(0.01, 2.0) var mouse_sensitivity = 0.5

var ui_locked = false

const CROUCH_HEIGHT = 0.7
const STANDING_HEIGHT = 1.8
const JUMP_VELOCITY = 10
const SPRINT_MULTIPLIER = 2.0
# Get the gravity from the project settings to be synced with RigidBody nodes.


var current_movement_state: e_movement_state
var speed = 1
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var friction = 0.2

var prev_target = null 

@onready var interaction_ray: RayCast3D = RayCast3D.new()
@onready var ground_ray: RayCast3D = RayCast3D.new()
@onready var head_ray: RayCast3D = RayCast3D.new()

@onready var start_friction = friction 
@onready var start_speed = speed
@onready var start_coyote_time = coyote_time

var coyote_time = 0.2

signal action

func _enter_tree():
	Global.player = self

func _ready(): 
	_init_rays()
	
func _process(delta):
	
	var offset = -STANDING_HEIGHT - (ground_ray.get_collision_point().y - camera.global_position.y) + 0.1
	head_ray.target_position = Vector3(0, -offset , 0)
	head_ray.global_transform.basis = Basis.IDENTITY

	if get_slide_collision_count() > 0: 
		velocity += get_last_slide_collision().get_normal() * 2
	
	if interaction_ray.is_colliding():
		if is_instance_valid(interaction_ray.get_collider()): 
			if interaction_ray.get_collider().has_signal("hit"):
				
				if prev_target != null: 
					if interaction_ray.get_collider() == prev_target: 
						prev_target = interaction_ray.get_collider()
						prev_target.hovered = true
						
					else: 
						prev_target.hovered = false
					prev_target = interaction_ray.get_collider()
					
				prev_target = interaction_ray.get_collider()
	else: 
		if is_instance_valid(prev_target):
			prev_target.hovered = false 
	if Input.is_action_just_pressed("action") and !ui_locked: 
	
		var scenario = Global.current_scenario
		
		if interaction_ray.is_colliding():
			if is_instance_valid(interaction_ray.get_collider()): 
				if interaction_ray.get_collider().get_class() == "RigidBody3D": 
					interaction_ray.get_collider().apply_central_impulse(
						-camera.global_transform.basis.z.normalized() * 20, 
					)
					
		
				if interaction_ray.get_collider().has_signal("hit"): 
					
					interaction_ray.get_collider().emit_signal("hit")
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
			
		var place_offset = (interaction_ray.get_collision_normal() * delta)
		emit_signal("action", interaction_ray.get_collision_point() + place_offset )
	
	var max_angle = deg_to_rad(88)
	camera.rotation.x = clamp(camera.rotation.x, -max_angle, max_angle)

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_vec = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_vec.x, 0, input_vec.y)).normalized()
	
	
	if !enable_movement: 
		return
	
	_crouch_move()
	
	match get_movement_state(): 
		e_movement_state["air"]: 
		
			apply_gravity()
			coyote_time -= delta
				
		e_movement_state["ground_walk"]: 
			_ground_move(direction)
			_ground_stick()
		e_movement_state["swim"]: 
			pass
	
	
	if Input.is_action_just_pressed("ui_accept") and is_grounded() or Input.is_action_just_pressed("ui_accept") and coyote_time > 0:
		velocity.y = 15
		velocity *= Vector3(1.5, 1, 1.5)
		coyote_time = 0
	
	move_and_slide()

func _ground_move(direction): 
	var delta = get_physics_process_delta_time()
	
	coyote_time = start_coyote_time
	
	if direction:
		velocity.x += direction.x * speed
		velocity.z += direction.z * speed
	
	Vector3.FORWARD.dot(Vector3.RIGHT)
	
	if rad_to_deg(get_ray_angle()) > 35: 
		direction = Vector3.ZERO
		apply_gravity()
	else: 
		apply_friction()
	
		
		if Input.is_action_pressed("sprint"): 
			speed = start_speed * SPRINT_MULTIPLIER
		else:
			speed = start_speed 

	velocity = velocity.slide(ground_ray.get_collision_normal())

func _crouch_move(): 
	if Input.is_action_pressed("crouch") or is_crouch_blocked(): 
		
		ground_ray.target_position = ground_ray.target_position.lerp(
			Vector3(0, -CROUCH_HEIGHT, 0), 
			get_physics_process_delta_time() * 5
		)
		speed = start_speed * 0.5
	else: 
		ground_ray.target_position = ground_ray.target_position.lerp(
			Vector3(0, -STANDING_HEIGHT, 0), 
			get_physics_process_delta_time() * 5
		)
		friction = start_friction

func _ground_stick(): 

	global_position.y = ground_ray.get_collision_point().y + -ground_ray.target_position.y - 0.1

func is_grounded() -> bool: 
	return ground_ray.is_colliding()

func is_crouch_blocked(): 
	return head_ray.is_colliding()
 
func is_crouching() -> bool: 
	return is_grounded() and Input.is_action_pressed("crouch")

func get_movement_state() -> e_movement_state: 
	
	if is_grounded() : 
		return e_movement_state["ground_walk"]
	elif !is_grounded(): 
		return e_movement_state["air"]
	elif can_swim(): 
		return e_movement_state["swim"]
	else: 
		return e_movement_state["none"]

func get_axis(): 
	return Input.get_axis("down", "up")

func get_ray_angle() -> float: 
	return ground_ray.get_collision_normal().angle_to(
		Vector3.UP
	)
	
func apply_friction(): 
	velocity += -1 * friction * velocity .length() * velocity.normalized()

func apply_gravity(): 
	var delta = get_physics_process_delta_time()
	velocity.y -= gravity * delta * 4

func _input(event):
	if event is InputEventMouseMotion: 
		if !ui_locked:
			rotate_object_local(Vector3.UP, -event.relative.x * (mouse_sensitivity / 100))
			camera.rotate_object_local(Vector3.RIGHT, -event.relative.y * ( mouse_sensitivity / 100))
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else: 
			Input.mouse_mode = Input.MOUSE_MODE_CONFINED
		
func _init_rays(): 
	add_child(ground_ray)
	camera.add_child(interaction_ray)
	camera.add_child(head_ray)
	interaction_ray.set_collision_mask_value(3, true)
	interaction_ray.target_position = Vector3(0,0,-500)
	interaction_ray.collide_with_areas = true
	ground_ray.target_position = Vector3(0, -STANDING_HEIGHT, 0)



func get_jump_input(): 
	return Input.is_action_just_pressed("jump")

func can_swim() -> bool: 
	return false 
