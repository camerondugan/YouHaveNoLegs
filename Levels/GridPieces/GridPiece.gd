extends Spatial

const gridSquare := 5
var gridPosition := Vector2.ZERO
var hasSpawnedEnemies := false
var spawner := preload("res://nodes/Basic Game Mechanics/SpawnAThing.tscn")
var drone := preload("res://nodes/Enemies/Drone.tscn")
export var gridSize := Vector2.ONE
export var adjacents := []

#updates the adjacent vectors as if rotated once
func rotateClockwise():
	for i in range(len(adjacents)):
		adjacents[i] = adjacents[i].rotated(deg2rad(-90))

func rotateClockwiseRepeat(x):
	for i in range(len(adjacents)):
		adjacents[i] = adjacents[i].rotated(deg2rad(-90)*x)

func _body_entered(body):
	if (body.name=="PlayerBody"):
		get_parent().setPlayerPosition(gridPosition)

func contains(pos):
	for h in range(gridSize.y-1):
		for w in range(gridSize.x-1):
			if (pos == gridPosition + Vector2(w,h)):
				return true
	return false

func spawnEnemies():
	if !hasSpawnedEnemies:
		var spawn = spawner.instance()
		spawn.spawnable = drone
		spawn.global_transform = global_transform
		spawn.translate(Vector3(1,0,1))
		get_parent().add_child(spawn)
		hasSpawnedEnemies = true
