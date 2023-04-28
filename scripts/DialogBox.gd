extends ColorRect

export var dialogPath = ""
export(float) var textSpeed = 0.05

var dialog
var phraseNum = 0
var finished = false
var waitingForResponse = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time = textSpeed
	dialog = getDialog()
	assert(dialog, "Dialog not found")
	nextPhrase()

func getDialog() -> Array:
	var f = File.new()
	assert(f.file_exists(dialogPath), "File does not exist")
	
	f.open(dialogPath, File.READ)
	var json = f.get_as_text()
	
	var output = parse_json(json)
	
	if typeof(output) == TYPE_ARRAY:
		return output
	else:
		return []
	
func nextPhrase() -> void:
	if phraseNum >= len(dialog):
		queue_free()
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
		for opt in dialog[phraseNum]["Options"]:
			$Options.bbcode_text += opt + "\n"
		waitingForResponse = true
		return

	finished = true
	phraseNum += 1
	return

func _process(delta):
	if waitingForResponse:
		#iterate through number key for each possible Option - output response somehow lol
		
		if Input.is_action_just_pressed("ui_accept"):
			finished = true
			phraseNum += 1
		else:
			return
	
	$Indicator.visible = finished
	if Input.is_action_just_pressed("ui_accept"):
		if finished:
			nextPhrase()
		else:
			$Text.visible_characters = len($Text.text)
