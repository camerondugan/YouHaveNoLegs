extends Spatial

export var speed = 1

func _process(delta):
	self.rotate_y(speed*2*PI*delta)
