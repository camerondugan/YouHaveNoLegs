extends RigidBody

onready var slerp = preload("res://scripts/Slerp.gd")
onready var core = $Visualizer


#On Collision
func _on_Light_Ball_body_entered(_body):
	pass

func onHitByPlayer():
	#Spawn Debree
	$BreakParticles.brek()
	#Delete Myself
	queue_free()
