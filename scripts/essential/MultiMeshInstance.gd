extends MultiMeshInstance

export(Vector3) var MaxOffset = Vector3.ONE
var halfMaxOffset
var blockSize = Vector3(.5,.1,.5)
var random = RandomNumberGenerator.new()

func randOffset():
	return Vector3(random.randf_range(-halfMaxOffset.x,halfMaxOffset.x),random.randf_range(-halfMaxOffset.y,halfMaxOffset.y),random.randf_range(-halfMaxOffset.z,halfMaxOffset.z))

func _ready():
	halfMaxOffset = MaxOffset/2.0
	random.randomize()
	var s :int= multimesh.instance_count
	var dim = int(sqrt(s))
	for x in range(dim):
		for z in range(dim):
			var instanceNum = z * dim + x
			multimesh.set_instance_transform(instanceNum, Transform(Basis(),Vector3((x-dim/2)*blockSize.x,0,blockSize.z*(-z+dim/2)) + randOffset() - Vector3(-blockSize.x/2,0,blockSize.z/2)))
