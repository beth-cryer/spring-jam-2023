extends Camera

onready var player = get_tree().get_current_scene().find_node("Player")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	translation.x=player.translation.x
