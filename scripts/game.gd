extends Spatial

var mobile:ARVRInterface = null
var ovr_performance = null
var ovr_init_config = null

func _ready():
	var VR := ARVRServer.find_interface("OpenVR")
	mobile = ARVRServer.find_interface("OVRMobile")
	if VR and VR.initialize():
		get_viewport().arvr = true
		get_viewport().hdr = false
		OS.vsync_enabled = false
		# Also, the physics FPS in the project settings is also 90 FPS. This makes the physics
		# run at the same frame rate as the display, which makes things look smoother in VR!
	elif mobile:
		ovr_init_config = preload("res://addons/godot_ovrmobile/OvrInitConfig.gdns").new()
		ovr_performance = preload("res://addons/godot_ovrmobile/OvrPerformance.gdns").new()
		ovr_init_config.set_render_target_size_multiplier(0.8)
		OS.vsync_enabled = false
		Engine.target_fps = 90
		if mobile.initialize():
			get_viewport().arvr = true
			get_viewport().hdr = false


var perform_runtime_config = false
func _process(_delta):
	if not perform_runtime_config:
		if mobile:
			ovr_performance.set_clock_levels(1, 1)
			ovr_performance.set_extra_latency_mode(1)
			ovr_performance.set_foveation_level(4)
			ovr_performance.set_enable_dynamic_foveation(true)
		perform_runtime_config = true
