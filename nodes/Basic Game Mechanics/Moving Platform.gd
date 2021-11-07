extends Spatial

onready var startPosition :Transform = $Platform.transform
onready var offsetPosition :Transform = $SecondPosition.transform
onready var changeDuration := 1.0
onready var curTransition := 0.0
onready var forward := true
export var speed := 0.4
onready var vel := Vector3.ZERO
onready var previous := Vector3.ZERO

func _process(delta):
	vel = $Platform.transform.origin - previous
	
	delta = delta * speed
	
	if forward:
		curTransition = min(1,curTransition+delta)
		if (curTransition == 1):
			forward = false
	else:
		curTransition = max(0,curTransition-delta)
		if (curTransition == 0):
			forward = true
	$Platform.transform = startPosition.interpolate_with(offsetPosition,curTransition)
	
	previous = $Platform.transform.origin

func velocity():
	return vel
