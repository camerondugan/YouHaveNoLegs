extends KinematicBody

onready var R_controller = get_tree().get_nodes_in_group("right controller")[0]
onready var L_controller = get_tree().get_nodes_in_group("left controller")[0]
onready var headset = get_tree().get_nodes_in_group("head")[0]

export var moveSpeed := 2
export var fallSpeed := 5

onready var velocity := Vector3.ZERO
func _physics_process(delta):
	velocity += Vector3.DOWN * fallSpeed * delta
	velocity += global_transform.origin.direction_to(headset.global_transform.origin).normalized() * moveSpeed * delta
	velocity = move_and_slide(velocity)

func playerHit():
	die()

func die():
	queue_free()
