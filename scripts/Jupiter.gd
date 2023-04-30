extends CSGSphere

onready var GameController = get_tree().get_current_scene()

func nextDialog():
	var dialogPath = "Jupiter_Dialog" + str(GameController.flags_dict["Jupiter_Dialog_Stage"]+1) + "_Part1"
	return dialogPath
