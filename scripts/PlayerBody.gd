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

func _physics_process(delta):
	#update variables
	var rc=Vector2(R_controller.translation.x,R_controller.translation.z)
	var lc=Vector2(L_controller.translation.x,L_controller.translation.z)
	var d=rc.distance_to(lc)
	var h=R_controller.translation.y-L_controller.translation.y
	var player_height=headset.translation.y
	var tmp = player_height*0.7
	var floating=d>tmp
	
	var count = get_slide_count()
	var grounded=count>0
	if (grounded):
		velocity*=friction
	#movement physics
	if (ciforce>0):
		iforce/=ciforce
		velocity=iforce
	else:
		var flying = floating and !grounded
		if (flying):
			var push = -headset.get_global_transform().basis[2]
			push.y=0
			push = push.normalized()
			velocity+=push*delta
			velocity.y=max(-0.3,velocity.y)
			var turn = h*PI/4*delta
			velocity=velocity.rotated(Vector3.UP,turn)
			#pick one not both
			#transform = transform.rotated(Vector3.UP,turn)
			transform.basis = transform.basis.rotated(Vector3.UP, turn*1.1)
	velocity.y -= gravity*delta
	ciforce=0
	iforce=Vector3.ZERO
	velocity = move_and_slide(velocity,Vector3.UP)
