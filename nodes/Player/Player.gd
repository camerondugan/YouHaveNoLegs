extends Spatial

var lives := 3
var invulnerable = false
var mouse_sensitivity = 0.002

onready var larm := get_node("VR/Headset Camera/prison-arms-left")
onready var rarm := get_node("VR/Headset Camera/prison-arms-left")
onready var camera := get_node("VR/Headset Camera")

func _process(_delta):
	if invulnerable:
		var tleft:int = int($Invulnerability.time_left*5)
		larm.visible = tleft%2==0
		rarm.visible = tleft%2==0

func _input(_event):
	var input_dir = Vector3()
	# desired move in camera direction
	if Input.is_action_pressed("move_forward"):
		input_dir += -camera.global_transform.basis.z
	if Input.is_action_pressed("move_back"):
		input_dir += camera.global_transform.basis.z
	if Input.is_action_pressed("move_left"):
		input_dir += -camera.global_transform.basis.x
	if Input.is_action_pressed("move_right"):
		input_dir += camera.global_transform.basis.x
	input_dir = input_dir.normalized()
	$PlayerBody.push(input_dir*3)
	return input_dir

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		$VR.rotate_x(-event.relative.y * mouse_sensitivity)
		rotate_y(-event.relative.x * mouse_sensitivity)
		$VR.rotation.x = clamp($VR.rotation.x, -1.2, 1.2)

func reduceLives(num):
	lives -= num
	invulnerable = true
	$Invulnerability.start()
	if (lives <= 0):
		var enemies := get_tree().get_nodes_in_group("Enemies")
		for enemy in enemies:
			enemy.die()
		queue_free()

func _exit_tree():
	if (!get_tree().reload_current_scene()):
		print("Failed to restart level")

func increaseLives(num):
	lives += num

func _on_Invulnerability_timeout():
	invulnerable = false
	larm.visible = true
	rarm.visible = true
