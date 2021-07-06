extends KinematicBody

onready var pbody = get_tree().get_nodes_in_group("body")[0]
onready var lc = get_tree().get_nodes_in_group("left controller")[0]
onready var rc = get_tree().get_nodes_in_group("right controller")[0]

var target_controller = null
export var cID = 0
export var speed = 20

onready var collisionShape = $CollisionShape
onready var previous = translation

func _ready():
	if (cID==1):
		target_controller = lc
	elif(cID==2):
		target_controller = rc
	if (target_controller):
		var mesh = target_controller.get_mesh()
		if (not mesh): return
		if(mesh.get_surface_count()>3): get_node("Mesh").set_mesh(rc.get_mesh())

var slide
func _physics_process(_delta):
	if (target_controller):
		#rotation
		self.global_transform.basis = target_controller.global_transform.basis
		
		#physics
		var dir = target_controller.global_transform.origin - global_transform.origin
		
		#snap if stuck
		if (dir.length()>0.35):
			global_transform.origin = target_controller.global_transform.origin
		dir*=speed
		
		#collision
		slide = move_and_slide(dir)
		var count = get_slide_count()
		var col = count>0
		if (col):
			var collis = get_slide_collision(0)
			var move = collis.normal * dir.length() * 3/5
			#hand friction
			move-=slide
			pbody.iforce += move
			pbody.ciforce +=1
