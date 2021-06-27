extends KinematicBody

var iforce = Vector3.ZERO

export var gravity = 9.8
var velocity = Vector3.ZERO
func _physics_process(delta):
	velocity.y -= gravity *delta
	velocity+=iforce
	iforce=Vector3.ZERO
	velocity = move_and_slide(velocity,Vector3.UP)
