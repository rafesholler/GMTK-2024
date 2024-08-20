extends Node

var ray_mode = "shrink"
var player_pos = Vector2.ZERO
var player_vel = Vector2.ZERO
var player_inv : Scalable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#print(player_inv)

func add_inventory(object: Scalable) -> void:
	player_inv = object

func remove_inventory() -> void:
	player_inv = null
