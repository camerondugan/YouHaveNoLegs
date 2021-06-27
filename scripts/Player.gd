extends ARVROrigin

var headset
var physics_body

func _ready():
	headset = self.get_node("Headset Camera")
	physics_body = get_tree().get_nodes_in_group("body")[0]

func _physics_process(delta):
	if (!headset or !physics_body): return
	self.global_transform=physics_body.global_transform
	self.global_transform=self.global_transform.translated(-headset.translation)
