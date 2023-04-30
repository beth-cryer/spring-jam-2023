extends Spatial

onready var Cam = $"Camera"
onready var Ray = $"Camera/Raycast"
onready var Text = get_tree().get_current_scene().find_node("HoverText")
onready var Canvas = get_tree().get_current_scene().find_node("CanvasLayer")
onready var GameController = get_tree().get_current_scene()

const ray_length = 1000
const SENSITIVITY = 0.5
const SMOOTHING = 5

var hoveredPlanet;

var camera_input : Vector2
var rotation_velocity : Vector2

func _input(event):
	if event is InputEventMouseMotion:
		camera_input = event.relative

func _process(delta):
	if !Cam.is_current():
		Text.text = ""
		return
	
	if !GameController.dialogOpen:
		#Camera movement
		rotation_velocity = rotation_velocity.linear_interpolate(camera_input * SENSITIVITY, delta * SMOOTHING)
		Cam.rotate_x(-deg2rad(rotation_velocity.y))
		rotate_y(-deg2rad(rotation_velocity.x))
		
		Cam.rotation_degrees.x = clamp(Cam.rotation_degrees.x, -90, 90)
		camera_input = Vector2.ZERO

		#Raycast check
		if Ray.is_colliding():
			#Check if planet, get name if so
			var planet = Ray.get_collider()
			if (planet.get_parent().name == "Planets"):
				Text.text = planet.name
				hoveredPlanet = planet
		else:
			hoveredPlanet = null
			Text.text = ""
		
		#Begin dialogue
		if hoveredPlanet != null and hoveredPlanet.has_method("nextDialog"):
			if Input.is_action_just_pressed("click"):
				var nextDialog = hoveredPlanet.nextDialog()
				if (nextDialog != ""):		
					var dialogBox = load("res://prefabs/DialogBox.tscn")
					var dialogInst = dialogBox.instance();
					dialogInst.dialogPath = nextDialog									
					Canvas.add_child(dialogInst)
					GameController.dialogOpen = true
