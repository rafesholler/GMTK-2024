extends CanvasLayer


signal game_started 

var level1_path = preload("res://Scenes and Scripts/Finalized Levels/Level 1/Level1.tscn")

func _process(delta):
	pass
	
func _on_play_button_pressed():
	get_parent().add_child(level1_path.instantiate())
	hide()


func _on_quit_button_pressed():
	get_tree().quit()
