extends Position3D

export var cullDirection := Vector3.ZERO

onready var player : Spatial = get_tree().get_nodes_in_group("body")[0]
onready var respawnSfx : Node = get_tree().get_nodes_in_group("respawnSfx")[0]

func _ready():
	cullDirection = cullDirection.abs()

func _process(_delta):
	var myAxis = global_transform.origin * cullDirection
	var bodyAxis = player.global_transform.origin * cullDirection
	if (myAxis.distance_squared_to(bodyAxis) < 0.2):
		player.respawn()
		respawnSfx.play()
