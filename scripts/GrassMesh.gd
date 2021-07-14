tool
extends MultiMeshInstance

export var extents := Vector2.ONE
export var spawn_outside_circle := false
export var radius := 12.0
onready var player = get_tree().get_nodes_in_group("body")
onready var visCol = $Area
onready var visShape:CollisionShape = $Area/CollisionShape

#func _enter_tree():
#	connect("visibility_changed", self, "_on_WindGrass_visibility_changed")

func _ready():
	if (len(player)>0):
		player = player[0]
		visible = global_transform.origin.distance_to(player.global_transform.origin)<visShape.shape.radius
	else:
		player = self
	radius *= scale.max_axis()
	var rng := RandomNumberGenerator.new()
	rng.randomize()

	var theta := 0
	var increase := 1
	var parent := get_parent_spatial()
	var center:Vector3
	if (parent):
		center =  parent.global_transform.origin
	else:
		center = global_transform.origin

	for i in multimesh.instance_count:
		var transform := Transform().rotated(Vector3.UP, rng.randf_range(-PI / 2, PI / 2))
		var x: float
		var z: float
		if ! spawn_outside_circle:
			x = rng.randf_range(-extents.x, extents.x)
			z = rng.randf_range(-extents.y, extents.y)
		else:
			x = center.x + (radius + rng.randf_range(0, extents.x)) * cos(theta)
			z = center.z + (radius + rng.randf_range(0, extents.y)) * sin(theta)
			theta += increase

		transform.origin = Vector3(x, 0, z)

		multimesh.set_instance_transform(i, transform)
	visible = false


#func _on_WindGrass_visibility_changed():
#	if visible:
#		_ready()


func _process(_delta):
	#Set character position based on node given in editor
	var ch:Vector3
	if (player):
		ch = player.global_transform.origin
	ch.y -= 0.2
	material_override.set_shader_param(
		"character_position", ch
	)


func _on_Area_body_entered(body):
	if (player == body):
		visible = true


func _on_Area_body_exited(body):
	if (player == body):
		visible = false
