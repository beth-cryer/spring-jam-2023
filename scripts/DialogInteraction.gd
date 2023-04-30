extends Sprite3D

onready var Canvas = get_tree().get_current_scene().find_node("CanvasLayer")
onready var GameController = get_tree().get_current_scene()
onready var InteractLabel = $"Label3D"

export var dialogPath = ""
export var condition : Dictionary = {"Var":"", "Val":""}

var interactArea = false;

func _ready():
	InteractLabel.hide()

func checkCondition():
	if GameController.flags_dict.has(condition["Var"]):
		return str(GameController.flags_dict.get(condition["Var"])) == condition["Val"]

func _process(delta):
	if interactArea and !GameController.dialogOpen and Input.is_action_just_released("interact"):
			if !checkCondition():
				return
					
			var dialogBox = load("res://prefabs/DialogBox.tscn")
			var dialogInst = dialogBox.instance();
			dialogInst.dialogPath = dialogPath									
			Canvas.add_child(dialogInst)
			GameController.dialogOpen = true

func _on_Area_body_entered(body):
	if body.name == "Player":
		interactArea = true
		if checkCondition():
			InteractLabel.show()

func _on_Area_body_exited(body):
	if body.name == "Player":
		interactArea = false
		InteractLabel.hide()
