extends Area2D

@export var one_shot := true
@export var off_texture : Texture2D
@export var on_texture : Texture2D
var activated = false

signal triggered

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is Ant:
		if not activated or not one_shot:
			triggered.emit()
			activated = !activated
			if activated:
				$Sprite2D.texture = on_texture
			else:
				$Sprite2D.texture = off_texture
