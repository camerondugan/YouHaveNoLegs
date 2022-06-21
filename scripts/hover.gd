extends RigidBody

export var bobSpeed := 2.0
export var bobAmount := 0.1

func _process(delta):
	gravity_scale = cos(OS.get_system_time_secs()*bobSpeed)*bobAmount
