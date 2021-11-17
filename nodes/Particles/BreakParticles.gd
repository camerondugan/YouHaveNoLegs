extends CPUParticles

onready var parent = get_parent()
onready var gparent = parent.get_parent()

#Break
func brek():
	$BreakSounds._play()
	$Timer.call_deferred("start",10)
	global_transform.origin = parent.global_transform.origin
	transform.origin = parent.transform.origin
	rotation = Vector3.ZERO
	parent.remove_child(self)
	gparent.add_child(self)
	emitting = true


func _on_Timer_timeout():
	queue_free()
