extends Timer

export(NodePath) onready var target

func _ready():
	target = get_node(target)

func reset():
	target.setVelocity(Vector3.ZERO)
	self.start()
