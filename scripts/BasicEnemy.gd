extends KinematicBody

onready var R_controller = get_tree().get_nodes_in_group("right controller")[0]
onready var L_controller = get_tree().get_nodes_in_group("left controller")[0]
onready var headset = get_tree().get_nodes_in_group("head")[0]

export var canFly := false
export var lookAtPlayer := false
export var moveSpeed := 3
export var fallSpeed := 5
export var knockBack := 7

var velocity := Vector3.ZERO

var lookWeight = 0.1

func _process(delta):
	var player = headset.global_transform.origin
	if not canFly:
		velocity += Vector3.DOWN * fallSpeed * delta
	velocity += global_transform.origin.direction_to(player-Vector3.UP*.2).normalized() * moveSpeed * delta
	velocity = move_and_slide(velocity)
	var rotated = global_transform.looking_at(player, Vector3.UP)
	global_transform = global_transform.interpolate_with(rotated,4*delta)
	#self.look_at(global_transform.origin + velocity,Vector3.UP)

func _onAttackAreaEntered(body):
	if (body.get_parent().is_in_group('player')):
		body = body.get_parent()
	if (body.is_in_group('player')):
		body.getHit(global_transform.origin.direction_to(headset.global_transform.origin).normalized() * knockBack/2)
		velocity = -velocity.normalized() * knockBack

func die():
	#$BreakParticles.brek()
	queue_free()

func setVelocity(vel):
	velocity = vel

func _on_Weak_Spot_Hit(body):
	if (body.get_parent().is_in_group('player')):
		body = body.get_parent()
	if (body.is_in_group('player')):
		die()
