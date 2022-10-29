extends Node

export(NodePath) var leadingNode
export(NodePath) var effectBox
var goToQueue = []
var currentTarget
var previousTarget
var interpolateTime := 0.0
export var updateTime := 0.1

func _ready():
	print(typeof(leadingNode))
	if (typeof(leadingNode)==TYPE_NODE_PATH):
		leadingNode = get_node(leadingNode)
	effectBox = get_node(effectBox)
	var reps = int(0.2 / updateTime)
	for _i in range(reps):
		goToQueue.push_back(self.global_transform)
	currentTarget = goToQueue.pop_front()
	previousTarget = self.global_transform
	
func _process(delta):
	interpolateTime += delta
	if (interpolateTime > updateTime):
		if is_instance_valid(leadingNode):
			goToQueue.append(leadingNode.global_transform)
			previousTarget = currentTarget
			currentTarget = goToQueue.pop_front()
			interpolateTime = 0.0
		else:
			if (has_node("BreakParticles")):
				$BreakParticles.brek()
			queue_free()
	if (currentTarget and previousTarget):
		self.global_transform = previousTarget.interpolate_with(currentTarget,interpolateTime/updateTime)
