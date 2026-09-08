extends Control

@onready var itemDisplay = $itemDisplay;

func hideTooltip():
	itemDisplay.visible = false
	
	pass

func placeInteractionPrompt(object: Interactable):
	if(object):
		var camera = get_viewport().get_camera_3d()
		var world_position = object.global_transform.origin
		if(camera.is_position_behind(world_position)):
			itemDisplay.visible = false;
		else:	
			var screen_position = camera.unproject_position(world_position)
			if(!itemDisplay.visible):
				itemDisplay.text = object.prompt;
				itemDisplay.visible = true;
			itemDisplay.position = screen_position;
