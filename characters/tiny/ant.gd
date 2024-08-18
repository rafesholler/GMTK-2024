extends CharacterBody2D
class_name Ant

@export var speed : float
@export var acceleration : float
@export_enum("Left:-1", "Right:1") var direction : int

func _ready() -> void:
	$RayCast2D.position.x *= direction

func _physics_process(delta: float) -> void:

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if not $RayCast2D.is_colliding() and velocity.y == 0:
		direction *= -1
		$RayCast2D.position.x *= -1
	if velocity.x == 0:
		direction *= -1
		$RayCast2D.position.x *= -1
	velocity.x = speed * direction
	
	#rotate the ant based off the slope of the ground
	if $SlopeRayCast.is_colliding():
		var vec = $SlopeRayCast.get_collision_normal()
		var rot = vec.angle_to(Vector2(0, -1)) * -1
		rotation = rot
		if velocity.x != 0 and velocity.y == 0 and abs(rot) > 4*PI/9:
			velocity = velocity.rotated(rot)
	
	move_and_slide()
