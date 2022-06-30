extends Spatial

export var speed = .5

func _process(delta):
	var amt = self.material.get_shader_param("dissolve_amount")
	if amt == null:
		amt = 0
	self.material.set_shader_param("dissolve_amount", min(1,delta*speed+amt))
