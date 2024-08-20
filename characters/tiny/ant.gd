extends CharacterBody2D
class_name Ant

@export var speed : float
@export var acceleration : float
@export_enum("Left:-1", "Right:1") var direction : int
@export var max_push_force = 20 #note: the player's push force is 50
var push_force = 0
var stopped = false
var timer = 0
func _ready() -> void:
	$RayCast2D.position.x *= direction

func _physics_process(delta: float) -> void:

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if not $RayCast2D.is_colliding() and velocity.y == 0:
		direction *= -1
		$RayCast2D.position.x *= -1
	#if velocity.x == 0 and is_on_floor():
		#timer += delta 
		#if timer >= 0.1:#necessary so ants don't instantly turn around whenever they bump into smth
			#direction *= -1
			#$RayCast2D.position.x *= -1
			#timer = 0
	
	velocity.x = speed * direction
	
	#rotate the ant based off the slope of the ground
	if $SlopeRayCast.is_colliding():
		var vec = $SlopeRayCast.get_collision_normal()
		var rot = vec.angle_to(Vector2(0, -1)) * -1
		rotation = rot
		if velocity.x != 0 and velocity.y == 0 and abs(rot) > 4*PI/9:
			velocity = velocity.rotated(rot)
	
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			#if push_force <= max_push_force:
				#push_force += delta*max_push_force
				c.get_collider().apply_central_impulse(-c.get_normal() * max_push_force)
	#print(push_force)
	#if get_slide_collision_count() == 0: push_force = 0
	#print(velocity.x)
	move_and_slide()
