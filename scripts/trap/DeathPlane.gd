extends Position3D

export var radius := 50000
export var cullDirection := Vector3.ZERO

onready var playerBody : Node = get_tree().get_nodes_in_group("playerBody")[0]
onready var respawnSfx : Node = get_tree().get_nodes_in_group("respawnSfx")[0]

func _ready():
	cullDirection = cullDirection.abs()

func _physics_process(_delta):
	checkForPlayerDeath()
	checkForEnemyDeath()
		
func markedForDeath(object):
	if (is_instance_valid(object)):
		var myAxis = global_transform.origin * cullDirection
		var objectAxis = object.global_transform.origin * cullDirection
		return (myAxis.distance_squared_to(objectAxis) < 0.2 && object.global_transform.origin.distance_to(self.global_transform.origin) <= radius)
	return false
	
func checkForPlayerDeath():
	if (markedForDeath(playerBody)):
		playerBody.get_parent().die()

func checkForEnemyDeath():
	var enemies := get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		if (markedForDeath(enemy)):
			enemy.die()
