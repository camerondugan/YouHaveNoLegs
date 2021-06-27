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

func _physics_process(delta):
	if (target_controller):
		var dir = target_controller.global_transform.origin - self.global_transform.origin
		move_and_slide(dir*speed,Vector3.UP)
	var count = get_slide_count()
	var tCol = Vector3.ZERO
	if (count>0):
		pass#collision must have happened
