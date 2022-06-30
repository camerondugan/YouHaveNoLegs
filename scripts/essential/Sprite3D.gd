extends Sprite3D


onready var player = get_tree().get_nodes_in_group("head")[0]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var target : Vector3 = player.global_transform.origin
	target.y = target.y + global_transform.origin.y
	target.y /= 2
	if (target.angle_to(Vector3.UP)>PI/2):
		look_at(target,Vector3.UP)
