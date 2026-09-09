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

var heldItem: Holdable = null;
var lookedAtObject: Interactable

var sprinting = false;
var speed = 5;
const JUMP_VELOCITY = 4.5

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	print(name.to_int())

func _ready():
	
	if !is_multiplayer_authority(): return
	camera.current = is_multiplayer_authority()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);

func pickupItem(item: Holdable):
	if !is_multiplayer_authority(): return
	
	heldItem = item;
	lookedAtObject = null;
	playerUI.hideTooltip();
	item.reparent(pickupMarker);
	item.rotation = Vector3(0, 0, 0);
	item.position = pickupMarker.position;
	pass

func getLookedAtObject():
	if !is_multiplayer_authority(): return
	
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
	if !is_multiplayer_authority(): return
	
	if(event is InputEventMouseMotion):
		camera.rotation.x -= event.relative.y * SENS;
		camera.rotation.x = clamp(camera.rotation.x, -CAMERA_CLAMP, CAMERA_CLAMP);
		rotate_y(-event.relative.x * SENS);
		camera.orthonormalize()
	elif (event.is_action_pressed("quit")):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif (event.is_action_pressed("interact") && lookedAtObject):
		lookedAtObject.interact(self)
	elif(event.is_action_pressed("interact") && heldItem):
		heldItem.drop(self);
		heldItem = null;
	elif(event.is_action_pressed('use') && heldItem is Usable):
		heldItem.use(self);
		
		
func _physics_process(delta: float) -> void:
	if !is_multiplayer_authority(): return
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	speed = BASE_SPEED;
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_pressed("sprint"):
		speed += SPRINT_SPEED
	
	if(!heldItem):
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
	

	
