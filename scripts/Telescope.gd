extends Sprite3D

onready var player = get_tree().get_current_scene().find_node("PlayerNode")
onready var camTP = get_tree().get_current_scene().find_node("CameraThirdPerson")
onready var camFP = get_tree().get_current_scene().find_node("CameraFirstPerson").get_node("Camera")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if Input.is_action_just_released("interact"):
		if (camFP.is_current()):
			camTP.make_current()
			player.show()
		else:
			camFP.make_current()
			player.hide()
