extends Spatial

export var target_group = ""
export var non_vr_target_group = ""
var target:NodePath
onready var ik:SkeletonIK = $Armature/Skeleton/SkeletonIK
onready var world := get_node("/root/World")

func _ready():
	if (!world.isInVR):
		ik.target_node = get_tree().get_nodes_in_group(non_vr_target_group)[0].get_path()
	else:
		ik.target_node = get_tree().get_nodes_in_group(target_group)[0].get_path()
	
	#if there's a target_node start inverse kinematics
	if (ik.target_node):
		ik.start()
