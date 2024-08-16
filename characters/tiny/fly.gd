extends CharacterBody2D

enum States {
	WANDER,
	DIVE,
	WAIT,
	RISE
}

@export var speed := 300.0
@export var acceleration := 10
@export var hover_height : float

var state = States.WANDER
var direction = randi_range(0, 1)

func _ready() -> void:
	if direction == 0: direction = -1

func _physics_process(delta: float) -> void:
	match state:
		States.WANDER:
			velocity.x = move_toward(velocity.x, speed*direction, acceleration)
			velocity.y = 0
			if $WanderTimer.is_stopped():
				$WanderTimer.start(randf_range(1, 2))
			velocity.x += Global.player_vel.x
		States.DIVE:
			if velocity.y == 0:
				state = States.WAIT
				$StateTimer.start(randf_range(1.5, 3.5))
			velocity.x = 0
			velocity.y = speed
		States.RISE:
			velocity.y = -speed
			if position.y >= hover_height:
				velocity.y = 0
				state = States.WANDER

	move_and_slide()


func _on_state_timer_timeout() -> void:
	match state:
		States.WANDER:
			state = States.DIVE
			velocity.y = speed
		States.WAIT:
			state = States.RISE
		States.RISE:
			velocity.y = 0
			state = States.WANDER


func _on_wander_timer_timeout() -> void:
	if state == States.WANDER:
		velocity.x *= -1
