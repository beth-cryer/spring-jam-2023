extends CSGSphere

onready var GameController = get_tree().get_current_scene()

func nextDialog():
	var stage = GameController.flags_dict["Saturn_Dialog_Stage"]
	var angered = GameController.flags_dict["Saturn_Angered"]
	
	if stage == 3: return ""
	
	var dialogPath = "Saturn_Dialog" + str(stage+1) + "_Part1"
	if angered:
		dialogPath += "_Angry"
		if stage == 0: dialogPath += "Return"
	return dialogPath
