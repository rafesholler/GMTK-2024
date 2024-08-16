extends CharacterBody2D


func _physics_process(delta: float) -> void:
	velocity.x = $Movement.smart_walk(delta)

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	
	move_and_slide()
