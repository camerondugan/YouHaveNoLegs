extends CPUParticles

#Break
func brek():
	#BUG No sound plays on hit(even if reparented)
	#SLOW Particles are too performance heavy
	transform = self.get_parent().global_transform
	self.rotation = Vector3.ZERO
	get_parent().get_parent().add_child(self)
	get_parent().remove_child(self)
	self.emitting = true
	$Timer.start(10)


func _on_Timer_timeout():
	queue_free()
