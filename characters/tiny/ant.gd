extends CharacterBody2D

@export var speed : float
@export var acceleration : float
@export var direction = 1 #-1 is left, 1 is right

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
	
	move_and_slide()
