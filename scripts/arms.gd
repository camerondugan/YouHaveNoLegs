extends Spatial

export var target_group = ""
var target:NodePath
onready var ik:SkeletonIK = $Armature/Skeleton/SkeletonIK

func _ready():
	target = get_tree().get_nodes_in_group(target_group)[0].get_path()
	ik.target_node = target
	ik.start()
