extends CharacterBody2D


@export var SPEED = 300.0
@export var JUMP_VEL = -500.0
@export var ACCEL = 8.0 
@export var FRICT = 10.0
@export var weight = 1
@export var max_health = 3
var health = max_health

var inventory : Scalable

var blue_beam = preload("res://Assets/Ray/BlueBeam.png")
var purple_beam = preload("res://Assets/Ray/PurpleBeam.png")

func _physics_process(delta: float) -> void:
	inventory = Global.player_inv
	
	# Handle jump w/ jump cutting and buffer zone.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		$JumpCutTimer.start(.2)
	
	#buffer jump for a few frames before landing
	if Input.is_action_just_pressed("Jump") and not is_on_floor():
		$JumpBufferTimer.start(.1)
	
	#jump if the player buffered it
	if is_on_floor() and not $JumpBufferTimer.is_stopped():
		$JumpCutTimer.start(.2)
	
	if Input.is_action_pressed("Jump") and not $JumpCutTimer.is_stopped():
		velocity.y = JUMP_VEL
	
	#prevents double jumping
	if Input.is_action_just_released("Jump") and not $JumpCutTimer.is_stopped():
		$JumpCutTimer.stop()
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += 9.8 * weight * delta
		
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
		$Raygun/Ray/CollisionShape2D.shape.size.x = $Raygun.global_position.distance_to($Raygun/RayCast2D.get_collision_point()) * 2
		$Raygun/Ray/CollisionShape2D.position.x = $Raygun/Ray/CollisionShape2D.shape.size.x/2
	else:
		$Raygun/Ray/Beam.size.x = 30000
		$Raygun/Ray/CollisionShape2D.shape.size.x = 30000
		$Raygun/Ray/CollisionShape2D.position.x = 15000
	
	if is_on_floor() and velocity.x == 0:
		$AnimatedSprite2D.play("Idle")
	if is_on_floor() and velocity.x != 0:
		$AnimatedSprite2D.play("Walk")
	if not is_on_floor():
		$AnimatedSprite2D.play("Jump")
	
	if get_global_mouse_position().x > self.position.x:
		$AnimatedSprite2D.flip_h = false
	elif get_global_mouse_position().x < self.position.x:
		$AnimatedSprite2D.flip_h = true
	
	#Handle Ray
		
	if Input.is_action_pressed("Shrink"):
		Global.ray_mode = "shrink"
		$Raygun/Ray.visible = true
		$Raygun/Ray.monitorable = true
		$Raygun/Ray/Beam.texture = purple_beam
		
	elif Input.is_action_pressed("Enlarge"):
		Global.ray_mode = "enlarge"
		$Raygun/Ray.visible = true
		$Raygun/Ray.monitorable = true
		$Raygun/Ray/Beam.texture = blue_beam
		
	else:
		$Raygun/Ray.visible = false
		$Raygun/Ray.monitorable = false

	Global.player_vel = velocity
	Global.player_pos = position
	move_and_slide()
	
	var push_force = 80.0
	
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Pick_Place") and inventory:
		inventory.global_position = get_global_mouse_position()
		get_parent().add_child(inventory)
		Global.remove_inventory()
