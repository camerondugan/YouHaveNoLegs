extends Node

export var sensitivity = .9
export var currentSetting = false
export var smoothing = 2
var lagCount = 0

func detect():
	var fps = Engine.get_frames_per_second()
	var target = OS.get_screen_refresh_rate()
	if (fps < target * sensitivity):
		lagCount+=1
	else:
		lagCount = 0

	var b = lagCount >= smoothing
	if (b != currentSetting):
		currentSetting = b
		for n in get_tree().get_nodes_in_group("Quality Switcher"):
			n.setLowQuality(currentSetting)
