extends MeshInstance

var speed := .5
var ignore_first_frame = true
var startSlideSound = false

#Handle animation of obelisk into game
func _process(delta):
	if (ignore_first_frame): #prevents from being seen before moved to final starting position
		ignore_first_frame = false
	else:
		if get_parent().isSeen:
			transform.origin.y = min(speed*delta+transform.origin.y,0)
			if transform.origin.y == 0:
				done()
			else:
				if not startSlideSound:
					get_parent().playSlideSounds()
					startSlideSound = true
				speed += speed*delta #Accelerate

func done():
	get_parent().obeliskSounds()
	get_parent().spawn()
	var particles = $Particles
	particles.emitting = true
	particles.emission_box_extents = get_parent().spawnable.instance().size/2
	particles.emission_box_extents += Vector3(0,get_parent().distanceFromGround/2,0)
	remove_child(particles)
	get_parent().add_child(particles)
	queue_free()
