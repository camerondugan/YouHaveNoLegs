extends Spatial

onready var R_controller = get_tree().get_nodes_in_group("right controller")[0]
onready var L_controller = get_tree().get_nodes_in_group("left controller")[0]
onready var headset = get_tree().get_nodes_in_group("head")[0]
onready var isInVR := false

#Restart
onready var player = get_tree().get_nodes_in_group("Player")[0]
onready var playerBody = get_tree().get_nodes_in_group("playerBody")[0]
onready var playerStartPos = playerBody.global_transform

func _ready():
	var VR = ARVRServer.find_interface("OpenXR")
	if not VR:
		VR = ARVRServer.find_interface("OVRMobile")

	if VR and VR.initialize():
		get_viewport().arvr = true

		#Manage Game Mode State
		isInVR = true

func restart():
	if (player.lives > 0):
		get_node("%ProcLevelGenerator").level_depth += 1
	else:
		get_node("%ProcLevelGenerator").level_depth -= 1

	player.reset()
	playerBody.reset()
	get_node("%ProcLevelGenerator").reset()
	var enemies := get_tree().get_nodes_in_group("Enemies")
	for enemy in enemies:
		enemy.queue_free() #Die
