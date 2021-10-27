extends RigidBody

onready var gap = $Visualizer/Case/Gaps
onready var core = $Visualizer

#Animated Opening
var opening := true
var speed := 1.5
#Gap
var gapSize := 5.0
var openGapSize := gapSize
var closeGapSize := 1.0
#Core
var coreSize = .6
var openCoreSize = coreSize
var closeCoreSize = .5

func _process(delta):
	scale_gap(delta)
	scale_core(delta)

func scale_gap(delta):
	if opening and gapSize < openGapSize:
		gapSize += delta * speed #+1 speed number of times per second
	elif(!opening and gapSize>closeGapSize):
		gapSize -= delta * speed
	gap.scale = Vector3.ONE * gapSize

func scale_core(delta):
	if opening and coreSize < openCoreSize:
		coreSize += delta * speed
	elif !opening and coreSize > closeCoreSize:
		coreSize -= delta * speed
	core.mesh.height = coreSize
	core.mesh.radius = coreSize/2.0

#On Collision
func _on_Light_Ball_body_entered(body):
	opening = false
