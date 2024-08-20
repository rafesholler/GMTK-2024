extends Area2D

var slow = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if slow:
		get_parent().get_node("Player").velocity = Vector2.ZERO

func _on_body_entered(body: Node2D) -> void:
	slow = true
	$Timer.start()


func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://Scenes and Scripts/Screens/screen_UI.tscn")
