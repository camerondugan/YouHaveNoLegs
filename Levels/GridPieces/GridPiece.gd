extends Spatial

const gridSquare := 5

var gridPosition := Vector3.ZERO
var hasSpawnedEnemies := false
var spawner := preload("res://nodes/Basic Game Mechanics/SpawnAThing.tscn")
var drone := preload("res://nodes/Enemies/Drone.tscn")

export var gridSize := Vector3.ONE
export var adjacents := []

#updates the adjacent vectors as if rotated once
func rotateClockwise():
	for i in range(len(adjacents)):
		adjacents[i] = adjacents[i].rotated(Vector3.UP,deg2rad(-90))

#Repeats rotations for easy coding
func rotateClockwiseRepeat(x):
	for i in range(len(adjacents)):
		adjacents[i] = adjacents[i].rotated(Vector3.UP,deg2rad(-90)*x)

func _body_entered(body):
	if (body.name=="PlayerBody"):
		#Code assumes parent is the proclevelgen
		get_parent().setPlayerPosition(gridPosition)

func contains(pos):
	for h in range(gridSize.y-1):
		for w in range(gridSize.x-1):
			for d in range(gridSize.z-1):
				if (pos == gridPosition + Vector3(w,h,d)):
					return true
	return false

func spawnEnemies():
	if !hasSpawnedEnemies:
		hasSpawnedEnemies = true

		var spawn = spawner.instance()
		spawn.spawnable = drone
		spawn.global_transform = global_transform

		var rng = RandomNumberGenerator.new()
		rng.randomize()
		#vvv update to be readable vvv
		var spawnXZ = Vector2(gridSquare*rng.randf_range(-.3,.3),gridSquare*rng.randf_range(-.3,.3))
		spawn.translate(Vector3(spawnXZ.x,0,spawnXZ.y))
		get_parent().add_child(spawn)
