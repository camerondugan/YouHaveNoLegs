extends Spatial

export var knockBack := 7

onready var headset = get_tree().get_nodes_in_group("head")[0]

var lookWeight = 0.1

func _ready():
	#die() # for debug reasons
	pass

func _onAttackAreaEntered(body):
	if (body.is_in_group('playerBody')):
		body.getHit(global_transform.origin.direction_to(headset.global_transform.origin).normalized() * knockBack/2)
	if (body.get_parent().is_in_group('playerBody')):
		body = body.get_parent()

func die():
	if (has_node("BreakParticles")):
		$BreakParticles.brek()
	queue_free()

func _on_Weak_Spot_Hit(body):
	if (body.get_parent().get_parent().is_in_group('playerBody')):
		body = body.get_parent().get_parent()
	if (body.get_parent().is_in_group('playerBody')):
		body = body.get_parent()
	if (body.is_in_group('playerBody')):
		die()
