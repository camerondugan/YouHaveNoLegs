extends Label

onready var world = get_node("/root/World")
onready var skipCheckForCycles = OS.get_screen_refresh_rate()*3
onready var cycles = 0

func _process(_delta):
	assert(world != null)
	var fps = Engine.get_frames_per_second()
	var target = OS.get_screen_refresh_rate()
	text = str(OS.get_screen_refresh_rate())
	text = str(Engine.get_frames_per_second())
	if (cycles < skipCheckForCycles):
		cycles += 1
	if (fps < target and cycles >= skipCheckForCycles):
		pass #Implement game rendering quality reduction
