extends KinematicBody

onready var pbody = get_tree().get_nodes_in_group("body")[0]
var target_controller = null
export var cID = 0
export var speed = 20

func _ready():
	if (cID==1):
		target_controller = get_tree().get_nodes_in_group("left controller")[0]
	elif(cID==2):
		target_controller = get_tree().get_nodes_in_group("right controller")[0]

var slide
func _physics_process(delta):
	if (target_controller):
		var dir = target_controller.global_transform.origin - self.global_transform.origin
		slide = move_and_slide(dir*speed,Vector3.UP)
	var count = get_slide_count()
	var col = count>0
	
	#collision
	if (col):
		var move = self.global_transform.origin - target_controller.global_transform.origin
		var tmp = get_slide_collision(0).normal
		move*= Vector3(abs(tmp.x),abs(tmp.y),abs(tmp.z))
		move*=18
		while count>0:
			count-=1
			#move += get_slide_collision(count).remainder
		#hand friction
		move-=slide*0.96
		pbody.iforce = move
	
	self.rotation = target_controller.rotation
