extends "res://scripts/DialogInteraction.gd"

func _process(delta):
	if GameController.flags_dict.has("Saturn_Mirror"):
		if GameController.flags_dict["Saturn_Mirror"] == true:
			queue_free()
			return
