extends StaticBody2D

var ground_text = load("res://Assets/World/Ground/Untitled_Artwork-1 17.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CollisionPolygon2D.polygon = $Path2D.curve.tessellate()
	$Polygon2D.polygon = $Path2D.curve.tessellate()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
