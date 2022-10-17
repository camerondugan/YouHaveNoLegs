extends ARVROrigin

onready var headset := get_node("Camera")
onready var world := get_node("/root/World")
onready var physics_body:KinematicBody = get_tree().get_nodes_in_group("playerBody")[0]

func _process(_delta):
	#Old implementation
	#global_transform=physics_body.global_transform
	#translate(-headset.translation)
	if (world.isInVR): #disable if not in vr
		translation = -headset.translation
