extends Interactable
class_name Holdable

@export var CollisionShape: CollisionShape3D;

func can_interact(player) -> bool:
	return true
	
func interact(player: Player) -> void:
	if(can_interact(player)):
		self.freeze = true;
		player.pickupItem(self);

func drop(player: Player) -> void:
	self.reparent(get_tree().current_scene);
	CollisionShape.disabled = false;
	self.freeze = false;
	player.heldItem = null;
	pass
