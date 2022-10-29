extends Spatial

export(NodePath) var highQuality
export(NodePath) var lowQuality
onready var skipCheckForCycles = OS.get_screen_refresh_rate()*3
onready var cycles = 0

func _ready():
	highQuality = get_node(highQuality)
	lowQuality = get_node(lowQuality)

func setLowQuality(l):
	highQuality.visible = not l
	lowQuality.visible = l
