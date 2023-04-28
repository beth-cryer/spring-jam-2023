extends Spatial

func _ready():
	pass # Replace with function body.


func _process(delta):
	if Input.is_action_pressed("quit"):
		get_tree().quit()
