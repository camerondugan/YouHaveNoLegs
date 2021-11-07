extends CPUParticles

onready var parent = get_parent()
onready var gparent = parent.get_parent()

#Break
func brek():
	transform = parent.global_transform
	rotation = Vector3.ZERO
	parent.remove_child(self)
	gparent.add_child(self)
	emitting = true
	$BreakSounds._play()
	$Timer.call_deferred("start",10)


func _on_Timer_timeout():
	queue_free()
