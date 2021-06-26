extends StaticBody

onready var head=get_tree().get_nodes_in_group("head")[0]
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	#assert(head!=null)
	self.translation=head.translation
