extends Spatial

onready var startPosition :Transform = $Door.transform
onready var offsetPosition :Transform = $OpenedPosition.transform
onready var changeDuration := 1.0
onready var curTransition := 0.0
onready var open = false

func _process(delta):
	if open:
		curTransition = min(1,curTransition+delta)
	else:
		curTransition = max(0,curTransition-delta)
	$Door.transform = startPosition.interpolate_with(offsetPosition,curTransition)

func _on_Button_body_entered(_body):
	open = !open
