extends Spatial

export var rotateSpeed = 1

func _process(delta):
	self.rotate_y(rotateSpeed*delta)
