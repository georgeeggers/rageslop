extends Node3D
class_name Interactable

@export var prompt: String;

func _ready():
	self.prompt = prompt;

func can_interact(player) -> bool:
	return false
	
func interact(player) -> void:
	pass
