extends KinematicBody

onready var pbody = get_tree().get_nodes_in_group("body")[0]
onready var lc = get_tree().get_nodes_in_group("left controller")[0]
onready var rc = get_tree().get_nodes_in_group("right controller")[0]

var target_controller = null
export var cID = 0
export var speed = 15

func _ready():
	var mesh
	if (cID==1):
		target_controller = get_tree().get_nodes_in_group("left controller")[0]
		mesh = lc.get_mesh()
	elif(cID==2):
		target_controller = get_tree().get_nodes_in_group("right controller")[0]
		mesh = rc.get_mesh()
	if (not mesh): return
	if(mesh.get_surface_count()>10):
		get_node("Mesh").set_mesh(rc.get_mesh())

var slide
func _physics_process(_delta):
	if (target_controller):
		var dir = target_controller.global_transform.origin - self.global_transform.origin
		dir*=speed
		#snap if stuck
		if (dir.length()>5):
			self.global_transform.origin = target_controller.global_transform.origin
		else:
			dir.slerp(self.global_transform.origin,0.2)
		slide = move_and_slide(dir)
		var count = get_slide_count()
		var col = count>0
		#collision
		if (col):
			var move = -dir/speed * 11
			#var tmp = get_slide_collision(0).normal
			#move*=11 * tmp.abs()
			#hand friction
			move-=slide*0.3
			pbody.iforce += move
			pbody.ciforce +=1
		self.rotation = target_controller.rotation
