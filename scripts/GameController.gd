extends Spatial

export var dialogOpen = false
export var telescopeMode = false

export var flags_dict: Dictionary = {
	"Jupiter_Dialog_Stage":0,
	"Jupiter_Mushroom":false,
	"Saturn_Dialog_Stage":0,
	"Saturn_Angered":false,
	"Saturn_Mirror":false
}

func _ready():
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_pressed("quit"):
		get_tree().quit()
