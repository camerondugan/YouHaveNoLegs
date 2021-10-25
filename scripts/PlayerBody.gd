extends KinematicBody

export var gravity := 5
export var friction := .95

onready var iforce := Vector3.ZERO
onready var ciforce := 0
onready var velocity := Vector3.ZERO
onready var mapStartPosition := global_transform.origin

onready var R_controller = get_tree().get_nodes_in_group("right controller")[0]
onready var L_controller = get_tree().get_nodes_in_group("left controller")[0]
onready var headset = get_tree().get_nodes_in_group("head")[0]
onready var vr_origin = get_tree().get_nodes_in_group("origin")[0]

var igrounded := false
var impact := false
func _process(delta):
	var count:= get_slide_count()
	var grounded:=count>0
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
		var rc:Vector2=Vector2(R_controller.translation.x,R_controller.translation.z)
		var lc:Vector2=Vector2(L_controller.translation.x,L_controller.translation.z)
		var d:float=rc.distance_to(lc)
		var player_height:float=headset.translation.y
		var tmp:float = player_height*0.75
		var floating:bool=d>abs(tmp)
		fly(floating and !grounded,delta)
	velocity.y -= gravity*delta
	velocity = move_and_slide(velocity)
	igrounded=grounded

func fly(is_flying:bool,delta:float):
	if (is_flying):
		#adding momentum over time
		var push:Vector3 = -headset.get_global_transform().basis[2]
		#h is for steering
		var h:float=R_controller.translation.y-L_controller.translation.y
		push.y=0
		push = push.normalized()
		velocity+=push*delta
		velocity.y=max(-0.3,velocity.y)
		var turn = h*PI/4*delta
		velocity=velocity.rotated(Vector3.UP,turn)
		#pick one not both
		#transform = transform.rotated(Vector3.UP,turn)
		transform.basis = transform.basis.rotated(Vector3.UP, turn*1.1)

func push(force:Vector3):
	iforce += force
	ciforce +=1

func respawn():
	global_transform.origin = mapStartPosition
	rotation = Vector3.ZERO
	velocity = Vector3.ZERO
	R_controller.global_transform.origin = mapStartPosition
	L_controller.global_transform.origin = mapStartPosition

