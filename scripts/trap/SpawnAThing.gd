extends Spatial

export var spawnable : PackedScene = null
export var distanceFromGround := 1.0

onready var obelisk := $Obelisk
onready var spawned = spawnable.instance()
onready var player = get_tree().get_nodes_in_group("playerBody")

func getBoundingBox(node):
	var size = node.size
	if size != null:
		return node.size
	else:
		print("spawned instance: " + node.name + " must have variable size")
		return Vector3.ZERO

func _ready():
	var newscale = getBoundingBox(spawned)
	obelisk.scale = newscale + Vector3(0,distanceFromGround,0)
	#starting height
	obelisk.translate(Vector3(0,(-distanceFromGround-newscale.y)/2,0)) 
	#target height
	self.translate(Vector3(0,(distanceFromGround+newscale.y)/2,0)) 

func spawn():
	#spawn at top of obelisk
	spawned.translate(Vector3(0,distanceFromGround/2,0))
	add_child(spawned)

func obeliskSounds():
	$StoneSlidingSound.playing = false
	$StoneBreakingSound.playing = true

func _on_Despawn_timeout():
	queue_free()
