extends KinematicBody

onready var pbody = get_tree().get_nodes_in_group("body")[0]
onready var lc:ARVRController = get_tree().get_nodes_in_group("left controller")[0]
onready var rc:ARVRController = get_tree().get_nodes_in_group("right controller")[0]

var target_controller:ARVRController = null
onready var audio:= $AudioStreamPlayer3D
export var cID := 0
export var speed := 20

onready var collisionShape:CollisionShape = $c
onready var previous := translation

func _ready():
	if (cID==1):
		target_controller = lc
	elif(cID==2):
		target_controller = rc

var slide
func _physics_process(delta):
	manage_rumble(target_controller,delta)
	if (target_controller):
		#rotation
		self.global_transform.basis = target_controller.global_transform.basis
		
		#physics
		var dir := target_controller.global_transform.origin - global_transform.origin
		
		#snap if stuck
		if (dir.length()>0.35):
			global_transform.origin = target_controller.global_transform.origin
		dir*=speed
		#collision
		slide = move_and_slide(dir)
		var count := get_slide_count()
		var col := count>0
		if (col):
			var collis:KinematicCollision = get_slide_collision(0)
			var move:Vector3 = collis.normal * dir.length() * 1/2
			#hand friction
			move-=slide
			pbody.push(move)

onready var rumbleDur = 0
func _on_contact(body):
	var c := 0
	var og:Node = body
	#checks self and 1 parent up
	while (body != null and c <= 1):
		if (body.get_groups().has("hitable")):
			target_controller.rumble = 0.5
			rumbleDur += 0.1
			audio.play()
		body = body.get_parent()
		c+=1

func manage_rumble(target_controller,delta):
	if (rumbleDur>0):
		rumbleDur -= delta
	else:
		target_controller.rumble = 0
