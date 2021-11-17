extends MeshInstance

var speed := .5


#Handle animation of obelisk into game
func _process(delta):
	transform.origin.y = min(speed*delta+transform.origin.y,0)
	if transform.origin.y == 0:
		done()
	else:
		speed += speed*delta

func obeliskSounds():
	get_parent().obeliskSounds()

func done():
	obeliskSounds()
	get_parent().spawn()
	var particles = $Particles
	particles.emitting = true
	particles.emission_box_extents = get_parent().spawnable.instance().size/2
	particles.emission_box_extents += Vector3(0,get_parent().distanceFromGround/2,0)
	remove_child(particles)
	get_parent().add_child(particles)
	queue_free()
