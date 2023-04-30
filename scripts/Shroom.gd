extends "res://scripts/DialogInteraction.gd"

func _process(delta):
	if GameController.flags_dict.has("Jupiter_Mushroom"):
		if GameController.flags_dict["Jupiter_Mushroom"] == true:
			queue_free()
			return
