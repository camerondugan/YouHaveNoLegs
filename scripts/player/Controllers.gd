extends KinematicBody

onready var pbody = get_tree().get_nodes_in_group("playerBody")[0]
onready var lc:ARVRController = get_tree().get_nodes_in_group("left controller")[0]
onready var rc:ARVRController = get_tree().get_nodes_in_group("right controller")[0]

var target_controller:ARVRController = null
onready var audio:= $AudioStreamPlayer3D
export var cID := 0
export var jumpPower := .35
export var runPower := .8

onready var collisionShape:CollisionShape = $c
onready var previous := translation
onready var world := get_node("/root/World")

onready var resetTimer := 0.0
onready var controllerResetDelay := 0.4

func _ready():
	if (cID==1):
		target_controller = lc
	elif(cID==2):
		target_controller = rc

var slide : Vector3
var time = 0
onready var startingTranslation = translation
func _physics_process(delta):
	manage_rumble(target_controller,delta)
	if (target_controller and world.isInVR):
		#rotation
		self.global_transform.basis = target_controller.global_transform.basis
		
		#physics
		var vecToHand = target_controller.global_transform.origin - global_transform.origin
		
		#snap if stuck
		if (vecToHand.length()>0.4):
			resetTimer += delta
			if (resetTimer>=controllerResetDelay):
				resetTimer=0.0
				#Snap to hand position
				global_transform.origin = target_controller.global_transform.origin
		vecToHand/=(delta*1.1)
		#collision
		slide = move_and_slide(vecToHand)
		var count := get_slide_count()-1
		while (count>=0):
			var collis:KinematicCollision = get_slide_collision(count)
			var verticalMove:Vector3 = collis.normal * vecToHand.length() * jumpPower
			var move = verticalMove-(slide*runPower)
			pbody.push(move)
			count-=1
	else:
		# Manage Arm Swing
		time+=delta
		var freq = 6
		var dist = 30
		var vel = pbody.velocity
		vel.y = 0
		if (cID == 1):
			translation.y = startingTranslation.y + ((sin(time*freq))/dist)*(vel.length())
		else:
			translation.y = startingTranslation.y - ((sin(time*freq))/dist)*(vel.length())
		if (time >= PI * 2):
			time = 0

onready var rumbleDur = 0
func _on_contact(body):
	var c := 0
	var hitSomething := true
	#checks self and 1 parent up
	while (body != null and c <= 1):
		if (body.has_method("onHitByPlayer")):
			body.onHitByPlayer()
		if (body.get_groups().has("soundless")):
			hitSomething = false
		body = body.get_parent()
		c+=1
	if (hitSomething and rumbleDur < .1):
		target_controller.rumble = 0.5
		rumbleDur += 0.1
		audio.play()

func manage_rumble(tc,delta):
	if (rumbleDur>0):
		rumbleDur -= delta
	else:
		tc.rumble = 0
