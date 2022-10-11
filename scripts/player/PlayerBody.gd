extends KinematicBody

export var gravity := 10.5
export var friction := .9
export var maxSpeed := 13.0

onready var iforce := Vector3.ZERO
onready var ciforce := 0
onready var velocity := Vector3.ZERO
onready var mapStartPosition := global_transform.origin

#SLOW: use get_node here for better performance
onready var R_controller = get_tree().get_nodes_in_group("right controller")[0]
onready var L_controller = get_tree().get_nodes_in_group("left controller")[0]
onready var headset = get_tree().get_nodes_in_group("head")[0]
onready var vr_origin = get_tree().get_nodes_in_group("origin")[0]

onready var player := get_parent()
onready var world := get_node("/root/World")

var igrounded := false
var impact := false

var speed = 7
const ACCEL_DEFAULT = 10
const ACCEL_AIR = 1
onready var accel = ACCEL_DEFAULT
var jump = 5

var cam_accel = 40
onready var windowSize = OS.get_window_size().y
var window_size_for_mouse_sense = 600
onready var mouse_sense = 0.002 * windowSize / window_size_for_mouse_sense
var mouse_sense_v_multi = 1.2
var controller_sense = 0.02
var snap

var can_jump_buffer = 0.0;
var cayote_time = 0.2

var angular_velocity = 30

var direction = Vector3()
var gravity_vec = Vector3()
var movement = Vector3()

onready var head = $"."
#onready var campivot = $"."
onready var mesh = $"."
	
var rot_x = 0
var rot_y = 0
func _input(event):
	if (!world.isInVR):
		#get mouse input for camera rotation
		if event is InputEventMouseMotion:
			#headset.rotate_y(deg2rad(-event.relative.x * mouse_sense))
			#headset.rotate_x(deg2rad(-event.relative.y * mouse_sense)) #Mouse look up (currently broken)
			rot_x += -event.relative.x * mouse_sense* mouse_sense_v_multi
			rot_y += -event.relative.y * mouse_sense 			
			transform.basis = Basis() # reset rotation
			rot_y = clamp(rot_y, deg2rad(-89), deg2rad(89))
			head.rotate_object_local(Vector3(0, 1, 0), rot_x) # first rotate in Y
			head.rotate_object_local(Vector3(1, 0, 0), rot_y) # then rotate in X

func non_vr_process(_delta):
	#Controller look
	rot_x += (controller_sense * (Input.get_action_strength("look_left") - Input.get_action_strength("look_right")))
	rot_y += (controller_sense * (Input.get_action_strength("look_up") - Input.get_action_strength("look_down")))
	transform.basis = Basis() # reset rotation
	rot_y = clamp(rot_y, deg2rad(-89), deg2rad(89))
	head.rotate_object_local(Vector3(0, 1, 0), rot_x) # first rotate in Y
	head.rotate_object_local(Vector3(1, 0, 0), rot_y) # then rotate in X
	#Menu open
	if Input.is_action_just_pressed("menu"):
		get_tree().quit()

func _physics_process(delta):
	if (!world.isInVR):
		#get keyboard input
		direction = Vector3.ZERO
		var h_rot = global_transform.basis.get_euler().y
		var f_input = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
		var h_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		direction = Vector3(h_input, 0, f_input).rotated(Vector3.UP, h_rot).normalized()
	
		#jumping and gravity
		if is_on_floor():
			snap = -get_floor_normal()
			accel = ACCEL_DEFAULT
			gravity_vec = Vector3.ZERO
		else:
			snap = Vector3.DOWN
			accel = ACCEL_AIR
			gravity_vec += Vector3.DOWN * gravity * delta
			
		if (!is_on_floor()):
			can_jump_buffer += delta
			can_jump_buffer = min(can_jump_buffer, cayote_time)
		else:
			can_jump_buffer = 0
		if Input.is_action_just_pressed("jump") and (can_jump_buffer < cayote_time):
			snap = Vector3.ZERO
			gravity_vec = Vector3.UP * jump
			can_jump_buffer = cayote_time
		
		#make it move
		velocity = velocity.linear_interpolate(direction * speed, accel * delta)
		movement = velocity + gravity_vec
		
		var _noop = move_and_slide(movement,Vector3.UP)
		#var _noop = move_and_slide_with_snap(movement, snap, Vector3.UP)

var once := false
func _process(delta):
	if (!once):
		if (!world.isInVR):
			#hides the cursor
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
			#mesh no longer inherits rotation of parent, allowing it to rotate freely
			#mesh.set_as_toplevel(true)
			once = true
	if (world.isInVR):
		vr_process(delta)
	else:
		non_vr_process(delta)

func vr_process(delta):
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
	
	#Limit Velocity
	if velocity.length_squared() > maxSpeed*maxSpeed:
		velocity = velocity.normalized() * maxSpeed
	
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

func getHit(force:Vector3):
	snap = Vector3.ZERO
	velocity = force
	direction = force.normalized()
	player.reduceLives(1)

func respawn():
	global_transform.origin = mapStartPosition
	rotation = Vector3.ZERO
	velocity = Vector3.ZERO
	R_controller.global_transform.origin = mapStartPosition
	L_controller.global_transform.origin = mapStartPosition

