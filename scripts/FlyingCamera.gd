extends Camera

export var flyspeed= 0.1
var view_sensitivity = 0.3
var mousedifference = Vector3()
var yaw = 0
var pitch = 0

func _ready():
	self.set_process_input(true)
	self.set_process(true)

func _enter_tree():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _exit_tree():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event):
	if(event.type == InputEvent.KEY):
		if(event.scancode == KEY_ESCAPE):
			self.get_tree().quit()
	
	if event.type == InputEvent.MOUSE_MOTION:
		yaw = fmod(yaw  - event.relative_x * view_sensitivity , 360)
		pitch = max(min(pitch - event.relative_y * view_sensitivity, 90), -90)
		self.set_rotation(Vector3(deg2rad(pitch), 0 , 0))
		self.set_rotation(Vector3(0, deg2rad(yaw), 0))

func _process(_delta):
	#mouse movement
	if(Input.is_key_pressed(KEY_W)):
		self.set_translation(self.get_translation() - get_global_transform().basis*Vector3(0,0,1) * flyspeed * .01)
	if(Input.is_key_pressed(KEY_S)):
		self.set_translation(self.get_translation() - get_global_transform().basis*Vector3(0,0,1) * flyspeed * -.01)
	if(Input.is_key_pressed(KEY_A)):
		self.set_translation(self.get_translation() - get_global_transform().basis*Vector3(1,0,0) * flyspeed * .01)
	if(Input.is_key_pressed(KEY_D)):
		self.set_translation(self.get_translation() - get_global_transform().basis*Vector3(1,0,0) * flyspeed * -.01)
