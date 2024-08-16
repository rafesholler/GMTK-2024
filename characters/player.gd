extends CharacterBody2D


@export var SPEED = 300.0
@export var JUMP_VEL = -400.0
@export var ACCEL = 8.0 
@export var FRICT = 10.0
@export var weight = 1
@export var max_health = 3
var health = max_health

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += 9.8 * weight
	
	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VEL

	# Handle Movement
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = move_toward(velocity.x,direction * SPEED, ACCEL)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICT)
	
	#Handle Visuals
	$Raygun.rotation = position.angle_to_point(get_global_mouse_position())
	if $Raygun/RayCast2D.is_colliding():
		$Raygun/Ray/Beam.size.x = $Raygun.global_position.distance_to($Raygun/RayCast2D.get_collision_point()) * 20
	else:
		$Raygun/Ray/Beam.size.x = 20000
	
	if is_on_floor() and velocity.x == 0:
		$AnimatedSprite2D.play("Idle")
	if is_on_floor() and velocity.x != 0:
		$AnimatedSprite2D.play("Walk")
	if not is_on_floor():
		$AnimatedSprite2D.play("Jump")
	
	if get_global_mouse_position().x > self.position.x:
		$AnimatedSprite2D.flip_h = false
		#$Ray.position.x = 0
		#$Ray/Sprite.flip_h = false
	elif get_global_mouse_position().x < self.position.x:
		$AnimatedSprite2D.flip_h = true
		#$Ray.position.x = -53.5
		#$Ray/Sprite.flip_h = true
	
	#Handle Ray
		
	if Input.is_action_pressed("Shrink"):
		Global.ray_mode = "shrink"
		#$Ray.visible = true
		#$Ray.monitorable = true
	elif Input.is_action_pressed("Enlarge"):
		Global.ray_mode = "enlarge"
		#$Ray.visible = true
		#$Ray.monitorable = true
	#else:
		#$Ray.visible = false
		#$Ray.monitorable = false

	move_and_slide()
