extends RigidBody2D

@export var scale_limit = .3
@export var base_scale = .5
var shrink_scale
var enlarge_scale

var scaling = false

func _ready() -> void:
	$Sprite2D.scale = Vector2(base_scale, base_scale)
	$CollisionShape2D.scale = Vector2(base_scale, base_scale)
	$Area2D/CollisionShape2D.scale = Vector2(base_scale, base_scale)
	shrink_scale = base_scale - scale_limit
	enlarge_scale = base_scale + scale_limit

func _physics_process(delta: float) -> void:
	if scaling:
		if Global.ray_mode == "shrink":
			if not($CollisionShape2D.scale.x < shrink_scale) :
				$Sprite2D.material.set("shader_parameter/width", 4)
				$Sprite2D.material.set("shader_parameter/color", Color(1,.5,1,.75))
				$CollisionShape2D.scale -= Vector2(.1*delta, .1*delta)
				$Sprite2D.scale -= Vector2(.1*delta, .1*delta)
				$Area2D/CollisionShape2D.scale -= Vector2(.1*delta, .1*delta)
			else:
				$Sprite2D.material.set("shader_parameter/width", 0)
		if Global.ray_mode == "enlarge":
			if not($CollisionShape2D.scale.x > enlarge_scale) :
				$Sprite2D.material.set("shader_parameter/width", 4)
				$Sprite2D.material.set("shader_parameter/color", Color(.5,1,1,.75))
				$CollisionShape2D.scale += Vector2(.1*delta, .1*delta)
				$Sprite2D.scale += Vector2(.1*delta, .1*delta)
				$Area2D/CollisionShape2D.scale += Vector2(.1*delta, .1*delta)
			else:
				$Sprite2D.material.set("shader_parameter/width", 0)
	else:
		$Sprite2D.material.set("shader_parameter/width", 0)
func _on_area_2d_area_entered(area: Area2D) -> void:
	scaling = true
	
func _on_area_2d_area_exited(area: Area2D) -> void:
	scaling = false
