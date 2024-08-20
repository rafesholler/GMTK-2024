extends ColorRect

var show = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if show == true:
		get_parent().get_parent().velocity = Vector2.ZERO
		print(modulate.a)
	if modulate.a >= 1.0:
		get_tree().change_scene_to_file("res://Scenes and Scripts/Screens/screen_UI.tscn")


func _on_timer_timeout() -> void:
	modulate.a += .2
	print("here")
	$Timer.start()
