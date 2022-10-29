extends Spatial

export(int) var length = 0
export(String) var bodyResourcePath
export(String) var bodyEndResourcePath
onready var head = get_node("Head")
var size = Vector3.ONE
var body
var prevBody = self
var bodyParts = []
onready var start = self.global_transform

func _ready():
	length = RandomNumberGenerator.new().randi_range(1,length)
	for i in range(max(0,length-1)):
		var last :bool= (i == length-2)
		if (last): body = load(bodyEndResourcePath)
		else: body = load(bodyResourcePath)
		body = body.instance()
		self.add_child(body)
		bodyParts.append(body)
		if (i == 0):
			body.leadingNode = head
		else:
			body.leadingNode = prevBody
			if (i != length-2):
				body.effectBox.connect("body_entered",head,"_onAttackAreaEntered")
			else:
				body.effectBox.connect("body_entered",head,"_on_Weak_Spot_Hit")
		prevBody = body
		
func _reset():
	self.global_transform = start
