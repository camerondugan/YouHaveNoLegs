extends Spatial

export var spawnable : PackedScene = null
export var distanceFromGround := 1.0
export var slideSoundPath:NodePath
export var breakingSoundPath:NodePath

onready var slideSound:AudioStreamPlayer3D = get_node(slideSoundPath)
onready var breakingSound:AudioStreamPlayer3D = get_node(breakingSoundPath)
onready var obelisk := $Obelisk
onready var isSeen := false
onready var spawned = spawnable.instance()
onready var player = get_tree().get_nodes_in_group("playerBody")

func _ready():
	var newscale = getBoundingBox(spawned)
	obelisk.scale = newscale + Vector3(0,distanceFromGround,0)
	#starting height
	obelisk.translate(Vector3(0,(-distanceFromGround-newscale.y)/2,0)) 
	#target height
	self.translate(Vector3(0,(distanceFromGround+newscale.y)/2,0)) 
	

func spawn():
	#spawn at top of obelisk
	spawned.global_transform = global_transform
	spawned.translate(Vector3(0,distanceFromGround/2,0))
	get_parent().add_child(spawned)

func getBoundingBox(node):
	var size = node.size
	if size != null:
		return node.size
	else:
		print("spawned instance: " + node.name + " must have variable size")
		return Vector3.ZERO

func playSlideSounds():
	slideSound.playing = true

func obeliskSounds():
	slideSound.playing = false
	breakingSound.playing = true

func _on_Despawn_timeout():
	queue_free()

func _on_VisibilityNotifier_screen_entered():
	isSeen = true
