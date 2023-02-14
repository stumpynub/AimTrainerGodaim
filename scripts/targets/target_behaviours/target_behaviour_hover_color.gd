extends Node

class_name TargetBehaviourHoverColor

@export_range(0, 10) var color_change_speed = 5
@onready var hover_mat = StandardMaterial3D.new()
@export var normal_color: Color
@export var hovered_color: Color
@export var mesh: MeshInstance3D

@export var color_on_hit = false 
@export var hit_color: Color

@onready var target: Target = get_parent()


func _ready():
	hover_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	target.hit.connect(_hit)
	hover_mat.albedo_color = normal_color
	
	if mesh == null: 
		if get_parent().has_method("get_mesh"): 
			mesh = get_parent().get_mesh()
			mesh.set_surface_override_material(0, hover_mat)
	else: 
		mesh.set_surface_override_material(0, hover_mat)
func _process(delta):
	if target.hovered: 
		hover_mat.albedo_color = hover_mat.albedo_color.lerp(hovered_color, delta * color_change_speed)
		print("hover")
	else: 
		hover_mat.albedo_color = hover_mat.albedo_color.lerp(normal_color, delta * color_change_speed)

func _hit():
	if mesh == null: 
		return 

	if color_on_hit: 
		hover_mat.albedo_color = hit_color
