extends GrooveJoint2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $RigidBody2D.position.y > 64:
		$String.size.y = (64 + (position.y - 64)) * 10
	else:
		$String.size.y = 64
