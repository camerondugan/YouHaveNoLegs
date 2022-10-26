extends Label

func _process(_delta):
	text = str(Engine.get_frames_per_second())
	text = str(OS.get_screen_refresh_rate())
