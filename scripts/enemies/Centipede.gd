extends Spatial

export(int) var length = 0
export(String) var bodyResourcePath
onready var head = get_node("Head")
var body
var prevBody = self

func _ready():
	for i in range(max(0,length-1)):
		body = load(bodyResourcePath)
		body = body.instance()
		if (i == 0):
			body.leadingNode = head
		else:
			body.leadingNode = prevBody
			for c in body.get_children():
				if c is Area:
					if (i != length-2):
						c.connect("body_entered",head,"_onAttackAreaEntered")
					else:
						c.connect("body_entered",head,"_on_Weak_Spot_Hit")
		if (i == length-2):
			pass
			#for c in body.get_children():
				#if c is MeshInstance:
					#c.mesh.in
		prevBody = body
		self.add_child(body)
