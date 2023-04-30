extends StaticBody

onready var Player = get_tree().get_current_scene().find_node("PlayerNode")
onready var CamTP = get_tree().get_current_scene().find_node("CameraThirdPerson")
onready var CamFP = get_tree().get_current_scene().find_node("CameraFirstPerson").get_node("Camera")
onready var InteractLabel = $"Label3D"

var interactArea = false

func _ready():
	InteractLabel.hide()

func _process(delta):
	if interactArea and Input.is_action_just_released("interact"):
		if (CamFP.is_current()):
			CamTP.make_current()
			Player.show()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)			
		else:
			CamFP.make_current()
			Player.hide()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_Area_body_entered(body):
	if body.name == "Player":
		interactArea = true
		InteractLabel.show()

func _on_Area_body_exited(body):
	if body.name == "Player":
		interactArea = false
		InteractLabel.hide()
