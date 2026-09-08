extends CharacterBody3D
class_name Player
@onready var camera = $Camera3D;
@onready var ray = $Camera3D/ShapeCast3D
@onready var itemDisplay = $playerUI/itemDisplay
@onready var playerUI = $playerUI
@onready var pickupMarker = $Camera3D/PickupMarker

const CAMERA_CLAMP = 1.5;
const SENS = 0.002;

const BASE_SPEED = 5;
@export var SPRINT_SPEED = 3;

const pickupDistance = Vector3(0, -1, 0);

var heldItem: Interactable = null;
var lookedAtObject: Interactable

var sprinting = false;
var speed = 5;
const JUMP_VELOCITY = 4.5



func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);

func pickupItem(item: Interactable):
	item.reparent(pickupMarker);
	item.position = pickupMarker.position;
	pass

func getLookedAtObject():
	
	if(ray.is_colliding()):
		var object = ray.get_collider(0);
		if(object is Interactable):
			lookedAtObject = object
			itemDisplay.text = object.prompt
			playerUI.placeInteractionPrompt(object);
		else:
			if(lookedAtObject):
				playerUI.hideTooltip()
				lookedAtObject = null
	else:
		if(lookedAtObject):
			playerUI.hideTooltip()
			lookedAtObject = null



func _input(event):
	if(event is InputEventMouseMotion):
		camera.rotation.x -= event.relative.y * SENS;
		camera.rotation.x = clamp(camera.rotation.x, -CAMERA_CLAMP, CAMERA_CLAMP);
		rotate_y(-event.relative.x * SENS);
		camera.orthonormalize()
	elif (event.is_action_pressed("quit")):
		get_tree().quit()
	elif (event.is_action_pressed("interact") && lookedAtObject):
		lookedAtObject.interact(self)
		
		
func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	speed = BASE_SPEED;
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_pressed("sprint"):
		speed += SPRINT_SPEED
	
	getLookedAtObject()
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("moveLeft", "moveRight", "moveForward", "moveBack")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
	

	
