extends MultiMeshInstance

export(Vector3) var MaxOffset = Vector3.ONE
onready var halfMaxOffset = MaxOffset/2.0
var random = RandomNumberGenerator.new()

func randOffset():
	return Vector3(random.randf_range(-halfMaxOffset.x,halfMaxOffset.x),random.randf_range(-halfMaxOffset.y,halfMaxOffset.y),random.randf_range(-halfMaxOffset.z,halfMaxOffset.z))

func _ready():

	var s :int= multimesh.instance_count
	var dim = int(sqrt(s))
	for x in range(dim):
		for z in range(dim):
			multimesh.set_instance_transform(z * dim + x, Transform(Basis(),Vector3(x-dim/2,0,-z+dim/2) + randOffset()))
