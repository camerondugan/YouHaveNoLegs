extends Position3D

export var cullDirection := Vector3.ZERO

onready var player : Spatial = get_tree().get_nodes_in_group("body")[0]
onready var respawnSfx : Node = get_tree().get_nodes_in_group("respawnSfx")[0]

func _ready():
	cullDirection = cullDirection.abs()

func _process(_delta):
	checkForPlayerDeath()
	checkForEnemyDeath()
		
func markedForDeath(object):
	var myAxis = global_transform.origin * cullDirection
	var objectAxis = object.global_transform.origin * cullDirection
	return myAxis.distance_squared_to(objectAxis) < 0.2
	
func checkForPlayerDeath():
	if (markedForDeath(player)):
		player.respawn()
		respawnSfx.play()

func checkForEnemyDeath():
	var enemies := get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		if (markedForDeath(enemy)):
			enemy.die()
