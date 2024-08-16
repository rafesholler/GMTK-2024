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
		
	#Handle Ray
	if direction > 0:
		$Ray.position.x = 0
		$Ray/Sprite.flip_h = false
	elif direction < 0:
		$Ray.position.x = -53.5
		$Ray/Sprite.flip_h = true
		
	if Input.is_action_pressed("Shrink"):
		Global.ray_mode = "shrink"
		$Ray.visible = true
		$Ray.monitorable = true
	elif Input.is_action_pressed("Enlarge"):
		Global.ray_mode = "enlarge"
		$Ray.visible = true
		$Ray.monitorable = true
	else:
		$Ray.visible = false
		$Ray.monitorable = false

	move_and_slide()
