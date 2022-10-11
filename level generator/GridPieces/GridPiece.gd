extends Spatial

const gridSquare := 5

var gridPosition := Vector3.ZERO
var rotations := 0
export var dusty := true
export var canSpawnEnemies := true
onready var spawner := preload("res://nodes/Basic Game Mechanics/SpawnAThing.tscn")
onready var drone := preload("res://nodes/Enemies/DroneEnemy.tscn")
onready var dust := preload("res://particles/environment/dust.tscn")

export var pieceSize := Vector3.ONE
export var adjacents := []
export var levelEndAreaPath:NodePath
var levelEndArea:Area
onready var world := get_node("/root/World")

func _ready():
	var d = dust.instance()
	add_child(d)
	d.global_transform.origin += Vector3(0,gridSquare/2.0,0)
	if (levelEndAreaPath):
		levelEndArea = get_node(levelEndAreaPath)

func _process(_delta):
	if (levelEndArea):
		if (levelEndArea.overlaps_body(world.player.get_child(0))):
			world.player.queue_free()

# updates the adjacent vectors as if rotated once
func rotateClockwise():
	rotations += 1
	self.rotation=Vector3.UP*deg2rad(-90)
	for i in range(len(adjacents)):
		adjacents[i] = adjacents[i].rotated(Vector3.UP,deg2rad(-90))
		adjacents[i] = roundV3(adjacents[i])

# Repeats rotations for easy coding
func rotateClockwiseRepeat(x):
	rotations = (rotations + x)%4
	self.rotation=Vector3.UP*deg2rad(-90*x)
	for i in range(len(adjacents)):
		adjacents[i] = adjacents[i].rotated(Vector3.UP,deg2rad(-90)*x)
		adjacents[i] = roundV3(adjacents[i])
		
func roundV3(vec):
	vec.x = removeNegZero(vec.x)
	vec.y = removeNegZero(vec.y)
	vec.z = removeNegZero(vec.z)
	return Vector3(round(vec.x),round(vec.y),round(vec.z))

func removeNegZero(i):
	if i == -0: i=0 
	return i

func _body_entered(body):
	if (body.name=="PlayerBody"):
		#Code assumes parent is the proclevelgen
		get_parent().setPlayerPosition(gridPosition)

# For grid position use
func isAt(pos):
	for h in range(self.gridPosition.y,self.gridPosition.y+pieceSize.y):
		for w in range(self.gridPosition.x,self.gridPosition.x+pieceSize.x):
			for d in range(self.gridPosition.z,self.gridPosition.z+pieceSize.z):
				if (pos == Vector3(w,h,d)):
					return true
	return false

func spawnEnemies():
	if canSpawnEnemies:
		canSpawnEnemies = false

		var spawn = spawner.instance()
		spawn.spawnable = drone
		spawn.global_transform = global_transform

		var rng = RandomNumberGenerator.new()
		rng.randomize()
		# vvv update to be readable vvv
		var spawnXZ = Vector2(gridSquare*rng.randf_range(-.3,.3),gridSquare*rng.randf_range(-.3,.3))
		spawn.translate(Vector3(spawnXZ.x,0,spawnXZ.y))
		get_parent().add_child(spawn)
