extends Node

export(NodePath) var leadingNode
export(NodePath) var initialSleep
var goToQueue = []
var currentTarget
var previousTarget
var interpolateTime := 0.0
export var updateTime := 0.1
var startMoving = false

func _ready():
	leadingNode = get_node(leadingNode)
	initialSleep = get_node(initialSleep)
	var reps = int(initialSleep.wait_time / updateTime)
	for _i in range(reps):
		goToQueue.push_back(self.global_transform)
	currentTarget = goToQueue.pop_front()
	previousTarget = self.global_transform
	
func _process(delta):
	if not startMoving: return
	interpolateTime += delta
	if (interpolateTime > updateTime):
		goToQueue.append(leadingNode.global_transform)
		previousTarget = currentTarget
		currentTarget = goToQueue.pop_front()
		interpolateTime = 0.0
	if (currentTarget and previousTarget):
		self.global_transform = previousTarget.interpolate_with(currentTarget,interpolateTime/updateTime)

func _on_update():
	pass

func _on_initialSleep_timeout():
	startMoving = true
