extends Node

#TargetNode

export(bool) var enabled = false
export(NodePath) var target_path
onready var target_node = get_node(target_path)

func _ready():
	if (!enabled):
		target_node.free()
