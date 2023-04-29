extends ColorRect

onready var GameController = get_tree().get_current_scene()

export var dialogPath : String = ""
export(float) var textSpeed = 0.05

var dialog
var phraseNum = 0
var finished = false
var options = []
var waitingForResponse = false
var next_json = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time = textSpeed
	dialog = getDialog()
	assert(dialog, "Dialog not found")
	nextPhrase()

func getDialog() -> Array:
	var f = File.new()
	var dialogPathFull = "dialog/" + dialogPath + ".json";
	if !f.file_exists(dialogPathFull):
		queue_free()
		GameController.dialogOpen = false
		return []
	
	f.open(dialogPathFull, File.READ)
	var json = f.get_as_text()
	
	var output = parse_json(json)
	
	if typeof(output) == TYPE_ARRAY:
		return output
	else:
		return []
	
func nextPhrase() -> void:
	if phraseNum >= len(dialog):
		queue_free()
		GameController.dialogOpen = false
		return
	
	#Condition (skip this phrase if condition false)
	if dialog[phraseNum].has("Condition"):
		if GameController.flags_dict.has(dialog[phraseNum]["Condition"]):
			if GameController.flags_dict.get(dialog[phraseNum]["Condition"]) == false:
				phraseNum += 1
				return
	
	finished = false
	
	$Name.bbcode_text = dialog[phraseNum]["Name"]
	$Text.bbcode_text = dialog[phraseNum]["Text"]
	$Options.bbcode_text = ""
	
	$Text.visible_characters = 0
	
	var f = File.new()
	var emotion = dialog[phraseNum]["Emotion"] if dialog[phraseNum].has("Emotion") else ""
	var img = "portraits/" + dialog[phraseNum]["Name"] + emotion + ".png"
	if f.file_exists(img):
		$Portrait.texture = load(img)
	else:
		$Portrait.texture = null
	
	while $Text.visible_characters < len($Text.text):
		$Text.visible_characters += 1
		
		$Timer.start()
		yield($Timer, "timeout")
	
	#Options (don't do next phrase until option picked)
	if dialog[phraseNum].has("Options"):
		options = dialog[phraseNum]["Options"]
		for i in range(options.size()):
			$Options.bbcode_text += str(i+1) + ". " + options[i]["Text"] + "\n"
		waitingForResponse = true
		return

	finished = true
	phraseNum += 1
	return

func linkToDialog(newDialogPath):
	dialogPath = newDialogPath
	phraseNum = 0
	finished = false
	waitingForResponse = false
	dialog = getDialog()
	assert(dialog, "Dialog not found")
	nextPhrase()

func _process(delta):
	if waitingForResponse:
		for i in range(options.size()):
			if Input.is_action_just_pressed("opt_"+str(i+1)):
				linkToDialog(options[i]["Link"])
		if !finished:
			return
		else:
			nextPhrase()
	
	$Indicator.visible = finished
	if Input.is_action_just_pressed("ui_accept"):
		if finished:
			if dialog[phraseNum-1].has("SetFlag"):
				var flagSetter = dialog[phraseNum-1]["SetFlag"]
				if GameController.flags_dict.has(flagSetter["Var"]):
					GameController.flags_dict[flagSetter["Var"]] = flagSetter["Val"]
			nextPhrase()
		else:
			$Text.visible_characters = len($Text.text)
