extends Holdable
class_name Usable

func can_use(player: Player) -> bool:
	return false;

func use(player: Player) -> void:
	print("using!")
