extends KinematicBody

var iforce = Vector3.ZERO

export var gravity = 3
export var friction = .95
var velocity = Vector3.ZERO

onready var R_controller = get_tree().get_nodes_in_group("right controller")[0]
onready var L_controller = get_tree().get_nodes_in_group("left controller")[0]
onready var headset = get_tree().get_nodes_in_group("head")[0]
var floating = true


func _physics_process(delta):
	#update conditionals
	
	var rc=Vector2(R_controller.global_transform.origin.x,R_controller.global_transform.origin.z)
	var lc=Vector2(L_controller.global_transform.origin.x,L_controller.global_transform.origin.z)
	var d=rc.distance_to(lc)
	var player_height=headset.translation.y
	var tmp = player_height*1/5
	print(d,"    ",tmp)
	floating=d>tmp
	
	var count = get_slide_count()
	var grounded=count>0
	if (count>0):
		velocity*=friction
	
	#movement physics
	if (iforce!=Vector3.ZERO):
		velocity=iforce
	else:
		velocity.y -= gravity*delta
		if (floating and !grounded):
			var push = -headset.get_global_transform().basis[2]
			push.y=0
			push = push.normalized()
			velocity+=push*delta
			velocity.y=max(-0.3,velocity.y)
			

	iforce=Vector3.ZERO
	velocity = move_and_slide(velocity,Vector3.UP)
	
