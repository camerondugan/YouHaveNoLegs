extends ARVROrigin

onready var headset := get_node("Headset Camera")
onready var physics_body:KinematicBody = get_tree().get_nodes_in_group("playerBody")[0]

func _process(_delta):
	global_transform=physics_body.global_transform
	translate(-headset.translation)
