extends Spatial

onready var R_controller = get_tree().get_nodes_in_group("right controller")[0]
onready var L_controller = get_tree().get_nodes_in_group("left controller")[0]
onready var headset = get_tree().get_nodes_in_group("head")[0]
onready var isInVR := false

func _ready():
	var VR = ARVRServer.find_interface("OpenXR")
	if not VR:
		VR = ARVRServer.find_interface("OVRMobile")

	if VR and VR.initialize():
		
		get_viewport().arvr = true
		
		#Manage Game Mode State
		isInVR = true
		
		#Settings to maybe load from user settings?
		#OS.vsync_enabled = false
		#Engine.target_fps = 72
