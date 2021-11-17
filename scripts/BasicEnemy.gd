extends KinematicBody

export var canFly := false
export var lookAtPlayer := false
export var moveSpeed := 3
export var fallSpeed := 5
export var knockBack := 7
export var size := Vector3.ONE

onready var headset = get_tree().get_nodes_in_group("head")[0]
var velocity := Vector3.ZERO

var lookWeight = 0.1

func _ready():
	#die()
	pass

func _process(delta):
	var player = null
	var rotated = null
	if headset:
		player = headset.global_transform.origin
	if not canFly:
		velocity += Vector3.DOWN * fallSpeed * delta
	if player:
		velocity += global_transform.origin.direction_to(player-Vector3.UP*.2).normalized() * moveSpeed * delta
	if player:
		rotated = global_transform.looking_at(player, Vector3.UP)
		global_transform = global_transform.interpolate_with(rotated,4*delta)
	velocity = move_and_slide(velocity)

func _onAttackAreaEntered(body):
	if (body.is_in_group('playerBody')):
		body.getHit(global_transform.origin.direction_to(headset.global_transform.origin).normalized() * knockBack/2)
		velocity = -velocity.normalized() * knockBack
	if (body.get_parent().is_in_group('playerBody')):
		body = body.get_parent()
		velocity = -velocity.normalized() * knockBack

func die():
	$BreakParticles.brek()
	queue_free()

func setVelocity(vel):
	velocity = vel

func _on_Weak_Spot_Hit(body):
	if (body.get_parent().is_in_group('playerBody')):
		body = body.get_parent()
	if (body.is_in_group('playerBody')):
		die()
