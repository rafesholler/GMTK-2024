extends Node2D
class_name Movement
#movement component to attach to enemies
@export var speed : float
@export var acceleration : float
@export var direction = 1 #-1 is left, 1 is right
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$RayCast2D.position.x *= direction
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func smart_walk(delta: float) -> float: #walk, but don't fall off the edge. only returns x value
		
	if not $RayCast2D.is_colliding() and get_parent().velocity.y == 0:
		direction *= -1
		$RayCast2D.position.x *= -1
	if get_parent().velocity.x == 0:
		direction *= -1
		$RayCast2D.position.x *= -1
	var vel = speed * direction
	return vel
	
	
	
	
