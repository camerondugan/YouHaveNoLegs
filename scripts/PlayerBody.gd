extends KinematicBody

var iforce = Vector3.ZERO
var ciforce = 0

export var gravity = 5
export var friction = .95
var velocity = Vector3.ZERO

onready var R_controller = get_tree().get_nodes_in_group("right controller")[0]
onready var L_controller = get_tree().get_nodes_in_group("left controller")[0]
onready var headset = get_tree().get_nodes_in_group("head")[0]
onready var vr_origin = get_tree().get_nodes_in_group("origin")[0]

var igrounded=false
var impact = false
func _physics_process(delta):
	var count = get_slide_count()
	var grounded=count>0
	if (grounded):
		velocity*=friction
	impact = not igrounded and grounded
	#movement physics
	if (ciforce>0):
		iforce/=ciforce
		velocity=iforce
		iforce=Vector3.ZERO
		ciforce=0
	else:
		var rc=Vector2(R_controller.translation.x,R_controller.translation.z)
		var lc=Vector2(L_controller.translation.x,L_controller.translation.z)
		var d=rc.distance_to(lc)
		var player_height=headset.translation.y
		var tmp = player_height*0.8
		var floating=d>tmp
		fly(floating and !grounded,delta)
	velocity.y -= gravity*delta
	velocity = move_and_slide(velocity)
	igrounded=grounded

func fly(is_flying,delta):
	if (is_flying):
		var push = -headset.get_global_transform().basis[2]
		var h=R_controller.translation.y-L_controller.translation.y
		push.y=0
		push = push.normalized()
		velocity+=push*delta
		velocity.y=max(-0.3,velocity.y)
		var turn = h*PI/4*delta
		velocity=velocity.rotated(Vector3.UP,turn)
		#pick one not both
		#transform = transform.rotated(Vector3.UP,turn)
		transform.basis = transform.basis.rotated(Vector3.UP, turn*1.1)
