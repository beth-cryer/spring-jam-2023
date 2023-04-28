extends Spatial

const ray_length = 1000
const SENSITIVITY = 0.5
const SMOOTHING = 5

var camera_input : Vector2
var rotation_velocity : Vector2

onready var cam = $"Camera"
onready var ray = $"Camera/Raycast"
onready var text = get_tree().get_current_scene().find_node("HoverText")

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		camera_input = event.relative

func _process(delta):
	if !cam.is_current():
		text.text = ""
		return
	
	#Camera movement
	rotation_velocity = rotation_velocity.linear_interpolate(camera_input * SENSITIVITY, delta * SMOOTHING)
	cam.rotate_x(-deg2rad(rotation_velocity.y))
	rotate_y(-deg2rad(rotation_velocity.x))
	
	cam.rotation_degrees.x = clamp(cam.rotation_degrees.x, -90, 90)
	camera_input = Vector2.ZERO

	#Raycast check
	if ray.is_colliding():
		#Check if planet, get name if so
		var planet = ray.get_collider()
		if (planet.get_parent().name == "Planets"):
			text.text = planet.name
	else:
		text.text = ""
