extends Interactable

@onready var collisionShape = $CollisionShape3D
	
func _ready():
	self.prompt = "E To Interact!";
	
func can_interact(player) -> bool:
	return true

func interact(player) -> void:
	print("Interacted!")
	collisionShape.disabled = true;
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector3(0.0, 0.0, 0.0), 0.5).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	await tween.finished
	queue_free()
