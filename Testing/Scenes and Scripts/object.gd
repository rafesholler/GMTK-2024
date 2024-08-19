extends RigidBody2D
class_name Scalable

@export var shrink_limit = .3
@export var enlarge_limit = .5
@export var base_scale = .5
@export var scale_speed = .1
@export var revert := false
@export var revert_timer := 3
@export var base_mass = 1
@export var push_force = 100 #quick fix. don't leave it like this
@export var pocketable := false
@export var pocket_texture : Texture2D

var shrink_scale
var enlarge_scale


var scaling = false
var reverting = false

var mouse_hovering = false

var scale_on_ready = true

func _ready() -> void:
	shrink_scale = base_scale - shrink_limit
	enlarge_scale = base_scale + enlarge_limit
	mass = base_mass * $CollisionShape2D.scale.x #note: this is in case we want to have a scaled up object that you need to scale down or smth 

func _physics_process(delta: float) -> void:
	
	if scale_on_ready:
		$Sprite2D.scale = Vector2(base_scale, base_scale)
		$CollisionShape2D.scale = Vector2(base_scale, base_scale)
		$Area2D/CollisionShape2D.scale = Vector2(base_scale, base_scale)

func _physics_process(delta: float) -> void:
	mass = $CollisionShape2D.scale.x * 2
	if scaling:
		$RevertTimer.stop()
		if Global.ray_mode == "shrink":
			if not($CollisionShape2D.scale.x < shrink_scale) :
				$Sprite2D.material.set("shader_parameter/width", 4)
				$Sprite2D.material.set("shader_parameter/color", Color(1,.5,1,.75))
				$CollisionShape2D.scale -= Vector2(scale_speed*delta, scale_speed*delta)
				$Sprite2D.scale -= Vector2(scale_speed*delta, scale_speed*delta)
				$Area2D/CollisionShape2D.scale -= Vector2(scale_speed*delta, scale_speed*delta)
			else:
				$Sprite2D.material.set("shader_parameter/width", 0)
		if Global.ray_mode == "enlarge":
			if not($CollisionShape2D.scale.x > enlarge_scale) :
				$Sprite2D.material.set("shader_parameter/width", 4)
				$Sprite2D.material.set("shader_parameter/color", Color(.5,1,1,.75))
				$CollisionShape2D.scale += Vector2(scale_speed*delta, scale_speed*delta)
				$Sprite2D.scale += Vector2(scale_speed*delta, scale_speed*delta)
				$Area2D/CollisionShape2D.scale += Vector2(scale_speed*delta, scale_speed*delta)
			else:
				$Sprite2D.material.set("shader_parameter/width", 0)
		mass = base_mass * $CollisionShape2D.scale.x
	else:
		$Sprite2D.material.set("shader_parameter/width", 0)
		if $RevertTimer.is_stopped() and revert:
			$RevertTimer.start(revert_timer)
	
	#reverts the object back to its original size over time if it hasn't been modified recently (based off revert_timer)
	if reverting:
		if $Sprite2D.scale.x > base_scale:
			$CollisionShape2D.scale -= Vector2(.1*delta, .1*delta)
			$Sprite2D.scale -= Vector2(.1*delta, .1*delta)
			$Area2D/CollisionShape2D.scale -= Vector2(.1*delta, .1*delta)
		elif $Sprite2D.scale.x < base_scale:
			$CollisionShape2D.scale += Vector2(.1*delta, .1*delta)
			$Sprite2D.scale += Vector2(.1*delta, .1*delta)
			$Area2D/CollisionShape2D.scale += Vector2(.1*delta, .1*delta)
		else:
			reverting = false
		mass = base_mass * $CollisionShape2D.scale.x
	
	#for i in get_slide_collision_count():
		#var c = get_slide_collision(i)
		#if c.get_collider() is RigidBody2D:
			#c.get_collider().apply_central_impulse(-c.get_normal() * push_force)
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Pick_Place"):
		if mouse_hovering and not Global.player_inv and $Sprite2D.scale.x <= shrink_scale:
			var new_node = duplicate(7)
			new_node.get_node("CollisionShape2D").scale = $CollisionShape2D.scale
			new_node.get_node("Sprite2D").scale = $Sprite2D.scale
			new_node.get_node("Area2D/CollisionShape2D").scale = $Area2D/CollisionShape2D.scale
			new_node.scale_on_ready = false
			Global.add_inventory(new_node)
			queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	scaling = true
	reverting = false
	
func _on_area_2d_area_exited(area: Area2D) -> void:
	scaling = false


func _on_revert_timer_timeout() -> void:
	reverting = true


func _on_area_2d_mouse_entered() -> void:
	mouse_hovering = true


func _on_area_2d_mouse_exited() -> void:
	mouse_hovering = false
