extends Interactable

@onready var collisionShape = $CollisionShape3D
	
func _ready():
	self.prompt = "E To Pickup";
	
func can_interact(player) -> bool:
	return true

func interact(player: Player) -> void:
	collisionShape.disabled = true;
	player.pickupItem(self);
