extends Spatial

const gridSquare := 5

var gridPosition := Vector3.ZERO
var rotations := 0
export var dusty := true
export var canSpawnEnemies := true
export var hazard := false
onready var spawner := preload("res://nodes/Basic Game Mechanics/SpawnAThing.tscn")
onready var drone := preload("res://nodes/Enemies/DroneEnemy.tscn")
onready var centipede := preload("res://nodes/Enemies/Centipede.tscn")
onready var dust := preload("res://particles/environment/dust.tscn")

export var pieceSize := Vector3.ONE
export var adjacents := []
export var levelEndAreaPath:NodePath
export var droneSpawnRate := .8
export var centipedeSpawnRate := .2
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
		if (world.has_node("Player")):
			if (levelEndArea.overlaps_body(world.player.get_child(0))):
				world.player.die()#kill player

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
	return Vector3(round(vec.x),round(vec.y),round(vec.z))

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
		var spawnStatsCap :float= droneSpawnRate + centipedeSpawnRate
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		if (rng.randf_range(0,1)<droneSpawnRate/spawnStatsCap):
			spawn.spawnable = drone
		else:
			spawn.spawnable = centipede 
		spawn.global_transform = global_transform

		var offset = Vector3(gridSquare*rng.randf_range(-.3,.3),0,gridSquare*rng.randf_range(-.3,.3))
		spawn.translate(offset)
		get_parent().add_child(spawn)
