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

func _process(delta):
	if not canFly:
		velocity += Vector3.DOWN * fallSpeed * delta
	if lookAtPlayer:
		var p = headset.global_transform.origin
		p.y = global_transform.origin.y
		self.look_at(p,Vector3.UP)
	velocity += global_transform.origin.direction_to(headset.global_transform.origin).normalized() * moveSpeed * delta
	velocity = move_and_slide(velocity)

func _onAttackAreaEntered(body):
	if (body.get_parent().is_in_group('player')):
		body = body.get_parent()
	if (body.is_in_group('player')):
		body.getHit(global_transform.origin.direction_to(headset.global_transform.origin).normalized() * knockBack)
	
func onHitByPlayer():
	velocity = headset.global_transform.origin.direction_to(global_transform.origin).normalized() * knockBack
	queue_free()

func die():
	$BreakParticles.brek()
	queue_free()

func setVelocity(vel):
	velocity = vel
